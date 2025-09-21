import serial
from serial.tools import list_ports

from time import sleep

from PySide6.QtCore import QObject, Signal, Slot, QThread, QTimer, QTime, QCoreApplication
from PySide6.QtWidgets import QApplication, QMainWindow, QPushButton, QComboBox, QTextEdit, QVBoxLayout, QHBoxLayout, QWidget, QLabel, QFileDialog, QSizePolicy, QGridLayout, QScrollArea, QLineEdit
from PySide6.QtCore import Qt, QThread, Signal, QPropertyAnimation, QEasingCurve, Property
from PySide6.QtGui import QIcon, QShortcut, QKeySequence

def red(text):
    return f'<p><span style="color: #ff0000">{text}</span></p>'
def green(text):
    return f'<p><span style="color: #00dd00">{text}</span></p>'
def yellow(text):
    return f'<p><span style="color: #ffff00">{text}</span></p>'
def blue(text):
    return f'<p><span style="color: #00aaff">{text}</span></p>'
def purple(text):
    return f'<p><span style="color: #ff00ff">{text}</span></p>'
def cyan(text):
    return f'<p><span style="color: #00ffff">{text}</span></p>'

serial_obj = None
Registers = [1]*0x3ff
Registers_length = len(Registers)

encoding = 'ascii'

class BlinkingLabel(QLabel):
    def __init__(self, text="", parent=None):
        super().__init__(text, parent)
        self._opacity = 1.0
        self.animation = QPropertyAnimation(self, b"opacity")
        self.animation.setDuration(500)  # 动画持续时间500ms
        self.animation.setEasingCurve(QEasingCurve.OutQuad)
        
    def get_opacity(self):
        return self._opacity
        
    def set_opacity(self, opacity):
        self._opacity = opacity
        # 更新样式表以应用透明度变化
        self.setStyleSheet(f"background-color: rgba(255, 255, 0, {opacity*0.7});")
        
    opacity = Property(float, get_opacity, set_opacity)
    
    def blink(self):
        """使标签闪烁一次"""
        # 停止任何正在进行的动画
        self.animation.stop()
        
        # 设置动画从当前透明度到0再到1
        self.animation.setStartValue(0)
        self.animation.setKeyValueAt(0.5, 1.0)
        self.animation.setEndValue(0)
        
        self.setStyleSheet("background-color: rgba(255, 255, 0, 0.7);")
        
        # 启动动画
        self.animation.start()
        
    def blink_with_times(self, times=1, interval=300):
        """使标签闪烁多次"""
        self.blink_count = 0
        self.max_blinks = times
        
        self.timer = QTimer()
        self.timer.timeout.connect(self._single_blink)
        self.timer.start(interval)
        
    def _single_blink(self):
        if self.blink_count < self.max_blinks:
            self.blink()
            self.blink_count += 1
        else:
            self.timer.stop()

class EditableLabel(QLabel):
    """支持双击编辑的QLabel组件"""
    editingFinished = Signal(int, int)  # 信号：编辑完成，参数(新值, 寄存器索引)

    def __init__(self, text="", register_index=-1, parent=None, base=10):
        super().__init__(text, parent)
        self.register_index = register_index
        self.base = base
        # 可以选中文本
        # self.setTextInteractionFlags(Qt.TextInteractionFlag.TextSelectableByMouse)
        self.setMinimumHeight(20)
        self.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)

        # 设置样式提示用户可编辑
        # self.setStyleSheet("""
        #     EditableLabel {
        #         border: 1px solid #cccccc;
        #         border-radius: 3px;
        #         padding: 2px;
        #         background-color: #f8f8f8;
        #     }
        #     EditableLabel:hover {
        #         background-color: #eef6ff;
        #         border: 1px solid #99c2ff;
        #     }
        # """)
        
    def mouseDoubleClickEvent(self, event):
        """处理双击事件"""
        if event.button() == Qt.MouseButton.LeftButton:
            self.showEditor()
            
    def showEditor(self):
        """显示编辑框"""
        self.line_edit = QLineEdit(self.text(), self)
        self.line_edit.setFrame(False)
        self.line_edit.selectAll()
        self.line_edit.setFocus()
        
        # 设置几何位置，使其覆盖QLabel
        self.line_edit.setGeometry(0, 0, self.width(), self.height())
        self.line_edit.show()
        
        # 连接信号
        # self.line_edit.returnPressed.connect(self.finishEditing)
        self.line_edit.editingFinished.connect(self.finishEditing)
        self.line_edit.focusOutEvent = self.focusOutEventOverride
        
    def focusOutEventOverride(self, event):
        """重写QLineEdit的focusOutEvent"""
        # self.finishEditing()
        new_text = self.line_edit.text()
        self.line_edit.deleteLater()

        # 验证是否有改写
        if new_text == self.text():
            return

        # 验证输入是否合法
        try:
            new_value = int(new_text, self.base)
            if new_value < 0 or new_value > 0xff:
                raise ValueError
            # 发射编辑完成信号
            self.editingFinished.emit(new_value, self.register_index)
        except ValueError:
            print(f"Invalid input: {new_text}")
            return
        
    def finishEditing(self):
        """完成编辑"""
        # 使对象失去焦点，从而触发focusOutEvent
        self.line_edit.clearFocus()




class RegisterDisplayWindow(QWidget):
    """用于显示寄存器值的子窗口"""

    def __init__(self, main_window, parent=None):
        super().__init__(parent)
        self.main_window = main_window
        self.setWindowTitle("Register Monitor")
        self.setGeometry(600, 100, 280, 600)

        min_width = 280
        self.setMinimumWidth(min_width)
        
        # 创建界面
        self.init_ui()
        
        # 初始更新一次显示
        self.update_display()
    
        # 按下ctrl + w 或者 escape关闭窗口
        self.shortcut = QShortcut(QKeySequence("Ctrl+W"), self)
        self.shortcut.activated.connect(self.main_window.window.close)

        self.shortcut = QShortcut(QKeySequence("Escape"), self)
        self.shortcut.activated.connect(self.main_window.window.close)


    def init_ui(self):
        """初始化用户界面"""
        main_layout = QVBoxLayout()

        # --- 标题行 ---
        header_layout = QGridLayout()
        header_layout.setColumnMinimumWidth(0, 55)
        header_layout.setColumnMinimumWidth(1, 35)
        header_layout.setColumnMinimumWidth(2, 35)
        header_layout.setColumnMinimumWidth(3, 75)
        # 整体左对齐
        header_layout.setAlignment(Qt.AlignmentFlag.AlignLeft)

        header_layout.addWidget(QLabel("  Address"), 0, 0, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Dec"), 0, 1, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Hex"), 0, 2, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Bin"), 0, 3, Qt.AlignLeft)
        main_layout.addLayout(header_layout)

        # 创建滚动区域
        scroll_area = QScrollArea()
        scroll_widget = QWidget()
        self.grid_layout = QGridLayout(scroll_widget)

        # 调整列宽(定值)
        self.grid_layout.setColumnMinimumWidth(0, 52)  # 地址列
        self.grid_layout.setColumnMinimumWidth(1, 33)  # 值列
        self.grid_layout.setColumnMinimumWidth(2, 35)  # 十六进制列
        self.grid_layout.setColumnMinimumWidth(3, 75)  # 二进制列
        
        # 设置标题行
        # self.grid_layout.addWidget(QLabel("Address"), 0, 0, Qt.AlignLeft)
        # self.grid_layout.addWidget(QLabel("Value"), 0, 1, Qt.AlignLeft)
        # self.grid_layout.addWidget(QLabel("Hex"), 0, 2, Qt.AlignLeft)
        # self.grid_layout.addWidget(QLabel("Bin"), 0, 3, Qt.AlignLeft)
        
        # 创建寄存器显示标签
        self.register_labels = []
        for i in range(Registers_length):
            # address_label = QLabel(f"0x{i:03X}")
            # value_label = QLabel("None")
            # hex_label = QLabel("None")
            # bin_label = QLabel("None")
            
            address_label = BlinkingLabel(f"0x{i:03X}")
            address_label.setAlignment(Qt.AlignLeft)
            value_label = EditableLabel("None", register_index=i, base=10)
            hex_label = EditableLabel("None", register_index=i, base=16)
            bin_label = EditableLabel("None", register_index=i, base=2)

            for lbl in (value_label, hex_label, bin_label):
                lbl.editingFinished.connect(self.finish_label_update)

            self.grid_layout.addWidget(address_label, i, 0)
            self.grid_layout.addWidget(value_label, i, 1)
            self.grid_layout.addWidget(hex_label, i, 2)
            self.grid_layout.addWidget(bin_label, i, 3)
            
            self.register_labels.append((value_label, hex_label, bin_label))
        
        scroll_area.setWidget(scroll_widget)
        main_layout.addWidget(scroll_area)

        self.refresh_button = QPushButton("Refresh")
        main_layout.addWidget(self.refresh_button)
        self.refresh_button.clicked.connect(self.update_all_regs)


        # save load layout
        # 添加保存和加载功能
        save_load_layout = QHBoxLayout()
        self.save_button = QPushButton("Save")
        self.load_button = QPushButton("Load")
        save_load_layout.addWidget(self.save_button)
        save_load_layout.addWidget(self.load_button)
        main_layout.addLayout(save_load_layout)

        self.save_button.clicked.connect(self.save_registers)
        self.load_button.clicked.connect(self.load_registers)

    
        # 添加跳转功能
        jump_layout = QHBoxLayout()
        jump_layout.addWidget(QLabel("To:"))
        
        self.jump_input = QLineEdit()
        self.jump_input.setPlaceholderText("Hex Address")
        # self.jump_input.setMaximumWidth(150)
        jump_layout.addWidget(self.jump_input)
        
        self.jump_button = QPushButton("Jump")
        self.jump_button.setMaximumWidth(80)
        jump_layout.addWidget(self.jump_button)
        self.jump_button.clicked.connect(self.jump_to_register)
        
        # 支持回车键跳转
        self.jump_input.returnPressed.connect(self.jump_button.click)
        
        main_layout.addLayout(jump_layout)


        self.setLayout(main_layout)

    def save_registers(self):
        """保存寄存器状态"""
        # 弹出文件对话框选择保存位置

        file_path, _ = QFileDialog.getSaveFileName(self, "Save Registers", "", "Text Files (*.txt)")

        if file_path:
            with open(file_path, "w") as f:
                for i, value in enumerate(Registers):
                    f.write(f"{i:03X}:{value:02X}\n")

    def load_registers(self):
        """加载寄存器状态"""
        file_path, _ = QFileDialog.getOpenFileName(self, "Load Registers", "", "Text Files (*.txt)")

        if file_path:
            with open(file_path, "r") as f:
                for line in f:
                    address, value = line.strip().split(":")
                    address = int(address, 16)
                    value = int(value, 16)
                    # self.update_reg_value(value, address)
                    self.main_window.send_data(f"{address:03X}{value:02X}")

    def jump_to_register(self):
        """跳转到指定寄存器"""
        text = self.jump_input.text().strip()
        
        if not text:
            return
        
        try:
            register_index = int(text, 16)
            
            # 检查索引是否有效
            if 0 <= register_index < Registers_length:
                # 获取对应的地址标签widget
                address_label = self.grid_layout.itemAtPosition(register_index, 0).widget()
                
                if address_label:
                    # 确保widget可见
                    address_label.setFocus()
                    
                    # 滚动到该widget位置
                    scroll_area = self.findChild(QScrollArea)
                    if scroll_area:
                        scroll_area.ensureWidgetVisible(address_label)
                        
                        # 可选：高亮显示目标行
                        self.grid_layout.itemAtPosition(register_index, 0).widget().blink()

            else:
                pass
                
        except ValueError:
            print(f"Invalid input: {text}")
            pass

    def finish_label_update(self, value, index):
        """处理编辑完成信号"""
        print(f"Editing finished: {value} (Register {index})")

        self.main_window.send_data(f"{index:03X}{value:02X}")
        # self.update_reg_value(value, index)

    def update_reg_value(self, value, index):
        Registers[index] = value
        self.update_reg_display(index)

    def update_reg_display(self, index):
        """更新单个寄存器显示"""
        if 0 <= index < Registers_length:
            value = Registers[index]
            value_label, hex_label, bin_label = self.register_labels[index]
            if value is None:
                value_label.setText("None")
                hex_label.setText("None")
                bin_label.setText("None")
            else:
                value_label.setText(str(value))
                hex_label.setText(f"0x{value:02X}")
                bin_label.setText(f"{value:08b}")

    def update_all_regs(self):
        """同步更新所有寄存器显示"""
        self.main_window.send_data("fffff")

    def update_display(self):
        """更新寄存器显示"""
        # for i, value in enumerate(Registers):
        for i in range(Registers_length):
            self.update_reg_display(i)

    def showEvent(self, event):
        """窗口显示时更新内容"""
        self.update_display()
        super().showEvent(event)


class ReceiveWorker(QObject):
    data_received = Signal(str)
    error_occurred = Signal()

    def __init__(self):
        super().__init__()
        self.shoud_work = False

    def run(self):
        self.shoud_work = True
        while self.shoud_work:
            # print("Debug: Waiting for data...")
            if serial_obj is not None and serial_obj.is_open:
                try:
                    data = serial_obj.readline().decode(encoding=encoding).strip()
                    print(f"Debug: Received data: {data}")
                    if data:
                        # 尝试读取多行
                        # while serial_obj.in_waiting:
                        #     more_data = serial_obj.readline().decode(encoding=encoding).strip()
                        #     if more_data:
                        #         data += "\n" + more_data
                        #     else:
                        #         break
                        # continue
                        self.data_received.emit(data)
                except Exception as e:
                    print(f"Error: {e}")
                    self.error_occurred.emit()
                    break
            # sleep(0.01)
    
    def stop(self):
        self.shoud_work = False

class HostGUI:
    def __init__(self):

        self.app = QApplication([])
        self.window = QMainWindow()

        self.app.setStyle("Fusion")
        # 字号加大
        self.app.setStyleSheet("QTextEdit, QPushButton, QComboBox, QLabel { font-size: 14px; }")

        self.window.setWindowTitle("Host GUI")
        self.window.setGeometry(100, 100, 500, 600)

        self.central_widget = QWidget()
        self.window.setCentralWidget(self.central_widget)

        self.layout = QVBoxLayout()
        self.central_widget.setLayout(self.layout)

        # 加上横向布局
        self.select_h_layout = QHBoxLayout()
        self.layout.addLayout(self.select_h_layout)

        self.label = QLabel("Select COM Port:")
        self.select_h_layout.addWidget(self.label)

        self.com_port_combo = QComboBox()
        # expanding the combo box to take available space
        self.com_port_combo.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)
        self.select_h_layout.addWidget(self.com_port_combo)


        # 加上横向布局
        self.connect_h_layout = QHBoxLayout()
        self.layout.addLayout(self.connect_h_layout)

        self.refresh_button = QPushButton("Refresh")
        self.connect_h_layout.addWidget(self.refresh_button)
        self.refresh_button.clicked.connect(self.populate_com_ports)

        self.connect_button = QPushButton("Connect")
        self.connect_h_layout.addWidget(self.connect_button)
        self.connect_button.clicked.connect(self.connect_to_com_port)

        # 显示过往的日志（包括接收和发送的，以及连接及断开连接的日志），不可编辑
        self.log_text_edit = QTextEdit()
        self.log_text_edit.setReadOnly(True)
        self.layout.addWidget(self.log_text_edit)
        # 段间距
        self.log_text_edit.setStyleSheet("QTextEdit { line-height: 0.5; }")

        # 添加发送按钮和文本框
        self.send_text_edit = QTextEdit()
        self.send_text_edit.setFixedHeight(100)
        self.layout.addWidget(self.send_text_edit)


        # 加上横向布局
        self.send_h_layout = QHBoxLayout()
        self.layout.addLayout(self.send_h_layout)

        self.clear_button = QPushButton("Clear Log")
        self.send_h_layout.addWidget(self.clear_button)
        self.clear_button.clicked.connect(self.clear_log)

        self.send_button = QPushButton("Send")
        self.send_h_layout.addWidget(self.send_button)
        self.send_button.clicked.connect(self.keyboard_send_data)

        # self.text_edit = QTextEdit()
        # self.layout.addWidget(self.text_edit)

        self.populate_com_ports()
        self.log_text_edit.clear()

        # 按下ctrl w 或者 escape关闭窗口
        # self.window.keyPressEvent = self.keyPressEvent
        self.shortcut = QShortcut(QKeySequence("Ctrl+W"), self.window)
        self.shortcut.activated.connect(self.window.close)

        self.shortcut = QShortcut(QKeySequence("Escape"), self.window)
        self.shortcut.activated.connect(self.window.close)

        self.window.closeEvent = self.closeEvent

        # 开启一个子窗口，用于显示寄存器的值
        self.register_window_button = QPushButton("Show Register Monitor")
        self.layout.addWidget(self.register_window_button)
        self.register_window_button.clicked.connect(self.show_register_window)

        self.show_register_window()
        


    def show_register_window(self):
        self.register_window = RegisterDisplayWindow(self)
        self.register_window.show()

    def clear_log(self):
        self.log_text_edit.clear()

    # def keyPressEvent(self, event):
    #     if event.key() == Qt.Key_W and event.modifiers() == Qt.ControlModifier:
    #         self.window.close()
    #     elif event.key() == Qt.Key_Escape:
    #         self.window.close()

    def closeWorkingThreads(self):
        if hasattr(self, 'receive_thread') and hasattr(self, 'receive_worker'):
            if self.receive_thread.isRunning():
                self.receive_worker.stop()
                self.receive_thread.quit()
                # self.receive_thread.wait()

    def closeEvent(self, event):
        # close thread
        self.closeWorkingThreads()

        # close window
        try:
            self.register_window.hide()
        except Exception as e:
            print(f"Error: {e}")
            pass

        if serial_obj:
            if serial_obj.is_open:
                serial_obj.close()
        event.accept()

    def populate_com_ports(self):
        self.log_text_edit.append(blue("Info: Refreshed COM port list."))
        ports = list_ports.comports()
        self.com_port_combo.clear()
        for port in ports:
            self.com_port_combo.addItem(port.device)

    def keyboard_send_data(self):
        data = self.send_text_edit.toPlainText().strip()
        if data == "":
            return
        else:
            self.send_data(data)

    def send_data(self, data: str):
        if serial_obj and serial_obj.is_open:
            try:
                serial_obj.write(data.encode(encoding=encoding))
                self.log_text_edit.append(f"Sent: {data}")
            except Exception as e:
                print(f"Error: {e}")
                self.log_text_edit.append(red(f"ERROR: Failed to send data: {e}"))
                self.connect_button.setText("Connect")
                self.closeWorkingThreads()
                serial_obj.close()
        else:
            self.log_text_edit.append(red("ERROR: Serial port is not open!"))

    def disconnect(self):
        self.closeWorkingThreads()
        serial_obj.close()
        self.connect_button.setText("Connect")
        self.log_text_edit.append(blue(f"Info: Disconnected from {serial_obj.port}"))

    def connect_to_com_port(self):
        global serial_obj
        # 如果未打开串口，则尝试连接
        if self.connect_button.text() == "Connect":
            selected_port = self.com_port_combo.currentText()
            if selected_port:
                try:
                    serial_obj = serial.Serial(selected_port, 115200, timeout=1)
                    if serial_obj.is_open:
                        self.connect_button.setText("Disconnect")
                        # 时刻监听串口数据
                        self.receive_thread = QThread()
                        self.receive_worker = ReceiveWorker()
                        self.receive_worker.moveToThread(self.receive_thread)
                        self.receive_thread.started.connect(self.receive_worker.run)
                        self.receive_worker.data_received.connect(self.receive_data)
                        self.receive_worker.error_occurred.connect(self.disconnect)
                        self.receive_thread.start()

                        self.log_text_edit.append(green(f"Info: Connected to {selected_port}"))
                except Exception as e:
                    print(f"Error: {e}")
                    self.log_text_edit.append(red(f"ERROR: Failed to connect to {selected_port}: {e}"))
            else:
                self.log_text_edit.append(red("ERROR: No COM port selected!"))
        else:
            self.disconnect()

    def run(self):
        self.window.show()
        self.app.exec()

    def receive_data(self, data):
        global Registers
        self.log_text_edit.append(f"Received: {data}")

        # 判断格式，是否为5个字符一行，且每个内容为5个十六进制小写数字
        # parts = data.split("\n")
        # for part in parts:
        #     # print(part)
        #     if len(part) != 6:
        #         continue
        #     else:
        #         try:
        #             idx = int(part[:3], 16)
        #             value = int(part[4:], 16)
        #             self.register_window.update_reg_value(value, idx)
        #         except ValueError:
        #             print(f"Invalid input: {part}")
        #             continue
        if len(data) == 6:
            try:
                idx = int(data[:3], 16)
                value = int(data[4:], 16)
                self.register_window.update_reg_value(value, idx)
            except ValueError:
                print(f"Invalid input: {data}")

        # self.register_window.update_display()


if __name__ == "__main__":
    gui = HostGUI()
    gui.run()
