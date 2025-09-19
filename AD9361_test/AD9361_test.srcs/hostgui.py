import serial
from serial.tools import list_ports

from time import sleep

from PySide6.QtCore import QObject, Signal, Slot, QThread, QTimer, QTime, QCoreApplication
from PySide6.QtWidgets import QApplication, QMainWindow, QPushButton, QComboBox, QTextEdit, QVBoxLayout, QHBoxLayout, QWidget, QLabel, QFileDialog, QSizePolicy, QGridLayout, QScrollArea, QLineEdit
from PySide6.QtCore import Qt, QThread, Signal
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
Registers = [None]*0x3ff

encoding = 'ascii'

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

        # 创建滚动区域
        scroll_area = QScrollArea()
        scroll_widget = QWidget()
        self.grid_layout = QGridLayout(scroll_widget)

        # 调整列宽(定值)
        self.grid_layout.setColumnMinimumWidth(0, 50)  # 地址列
        self.grid_layout.setColumnMinimumWidth(1, 35)  # 值列
        self.grid_layout.setColumnMinimumWidth(2, 35)  # 十六进制列
        self.grid_layout.setColumnMinimumWidth(3, 75)  # 二进制列
        
        # 设置标题行
        self.grid_layout.addWidget(QLabel("Address"), 0, 0, Qt.AlignLeft)
        self.grid_layout.addWidget(QLabel("Value"), 0, 1, Qt.AlignLeft)
        self.grid_layout.addWidget(QLabel("Hex"), 0, 2, Qt.AlignLeft)
        self.grid_layout.addWidget(QLabel("Bin"), 0, 3, Qt.AlignLeft)
        
        # 创建寄存器显示标签
        self.register_labels = []
        for i in range(len(Registers)):
            # address_label = QLabel(f"0x{i:03X}")
            # value_label = QLabel("None")
            # hex_label = QLabel("None")
            # bin_label = QLabel("None")
            
            address_label = QLabel(f"0x{i:03X}")
            value_label = EditableLabel("None", register_index=i, base=10)
            hex_label = EditableLabel("None", register_index=i, base=16)
            bin_label = EditableLabel("None", register_index=i, base=2)

            for lbl in (value_label, hex_label, bin_label):
                lbl.editingFinished.connect(self.finish_label_update)

            self.grid_layout.addWidget(address_label, i+1, 0)
            self.grid_layout.addWidget(value_label, i+1, 1)
            self.grid_layout.addWidget(hex_label, i+1, 2)
            self.grid_layout.addWidget(bin_label, i+1, 3)
            
            self.register_labels.append((value_label, hex_label, bin_label))
        
        scroll_area.setWidget(scroll_widget)
        main_layout.addWidget(scroll_area)
        
        # 添加控制按钮
        button_layout = QHBoxLayout()

        self.refresh_button = QPushButton("Refresh")
        button_layout.addWidget(self.refresh_button)
        main_layout.addLayout(button_layout)
        self.refresh_button.clicked.connect(self.update_display)   

        self.setLayout(main_layout)

    def finish_label_update(self, value, index):
        """处理编辑完成信号"""
        print(f"Editing finished: {value} (Register {index})")

        self.main_window.send_data(f"{index:03X}{value:02X}")
        # self.update_reg_value(value, index)

    def update_reg_value(self, value, index):
        Registers[index] = value
        self.update_reg(index)

    def update_reg(self, index):
        """更新单个寄存器显示"""
        if 0 <= index < len(Registers):
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

    def update_display(self):
        """更新寄存器显示"""
        for i, value in enumerate(Registers):
            self.update_reg(i)

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
            if serial_obj is not None and serial_obj.is_open:
                try:
                    data = serial_obj.readline().decode(encoding=encoding).strip()
                    if data:
                        self.data_received.emit(data)
                except Exception as e:
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
        except:
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
        parts = data.split()
        for part in parts:
            if len(part) != 5:
                continue
            else:
                try:
                    idx = int(part[:3], 16)
                    value = int(part[3:], 16)
                    self.register_window.update_reg_value(value, idx)
                except ValueError:
                    continue

        # self.register_window.update_display()


if __name__ == "__main__":
    gui = HostGUI()
    gui.run()
