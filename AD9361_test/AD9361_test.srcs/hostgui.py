import serial
from serial.tools import list_ports

import time
from time import sleep

import sys
import math

from PySide6.QtWidgets import QApplication, QMainWindow, QPushButton, QComboBox, QTextEdit, QVBoxLayout, QHBoxLayout, QWidget, QLabel, QFileDialog, QSizePolicy, QGridLayout, QScrollArea, QLineEdit, QFrame, QSplitter
from PySide6.QtCore import QTimer, QObject, Qt, QThread, Signal, QPropertyAnimation, QEasingCurve, Property
from PySide6.QtGui import QIcon, QShortcut, QKeySequence


def red(text):
    return f'<span style="color: #ff0000; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


def green(text):
    return f'<span style="color: #00dd00; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


def yellow(text):
    return f'<span style="color: #ffff00; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


def blue(text):
    return f'<span style="color: #00aaff; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


def purple(text):
    return f'<span style="color: #ff00ff; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


def cyan(text):
    return f'<span style="color: #00ffff; margin-top: 60px; margin-bottom: 0px;">{text}</span>'


serial_obj = None
Registers = [None] * 0x3FF
# Registers = [None]+[1]*0x3fe
Registers_length = len(Registers)

encoding = "ascii"


class FrequencyLineEdit(QLineEdit):
    """自定义频率输入框，带有验证功能"""

    good_line_style = "QLineEdit { border: 1px solid #41ADFF; border-radius: 4px; padding: 2px; }"
    bad_line_style = "QLineEdit { border: 1px solid red; border-radius: 4px; padding: 2px; }"

    def __init__(self, ori_value="", parent=None):
        super().__init__(parent)

        self.is_valid = True  # 验证状态
        self.setText(str(ori_value))  # 初始值
        self.validate_frequency(self.text())  # 初始验证

        self.textChanged.connect(self.validate_frequency)

    def validate_frequency(self, text):
        """验证频率输入"""
        try:
            # 尝试转换为浮点数
            freq = float(text)

            # 检查是否在三个允许的范围内
            if (389.5 <= freq <= 510.0) or (779 <= freq <= 1020) or (2400 <= freq <= 2483.5):
                self.is_valid = True
                self.setStyleSheet(self.good_line_style)
            else:
                self.is_valid = False
                self.setStyleSheet(self.bad_line_style)

        except ValueError:
            # 如果不是有效的数字
            self.is_valid = False
            self.setStyleSheet(self.bad_line_style)

        # print(f"状态: {self.is_valid}")


# 横线
def HLine():
    # 上下间距
    margin = 8
    # 线宽
    hline_layout = QVBoxLayout()
    hline = QWidget()
    hline.setFixedHeight(1)
    hline.setStyleSheet("background-color: gray;")
    hline_layout.setContentsMargins(0, margin, 0, margin)
    hline_layout.addWidget(hline)
    actual_hline = QWidget()
    actual_hline.setLayout(hline_layout)
    return actual_hline


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
            if new_value < 0 or new_value > 0xFF:
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


class RegisterDisplayWindow(QFrame):
    """用于显示寄存器值的子窗口"""

    def __init__(self, main_window, parent=None):
        super().__init__(parent)
        self.main_window = main_window
        # self.setWindowTitle("Register Monitor")
        # self.setGeometry(600, 100, 280, 600)

        fixed_width = 260 + 16
        # fixed_width = 450
        # self.setMinimumWidth(min_width)
        # self.setFixedWidth(fixed_width)
        self.setMinimumWidth(fixed_width)

        # 创建界面
        self.init_ui()

        # 初始更新一次显示
        self.update_display()

        # 按下ctrl + w 或者 escape关闭窗口
        # self.shortcut = QShortcut(QKeySequence("Ctrl+W"), self)
        # self.shortcut.activated.connect(self.main_window.window.close)

        # self.shortcut = QShortcut(QKeySequence("Escape"), self)
        # self.shortcut.activated.connect(self.main_window.window.close)

    def init_ui(self):
        """初始化用户界面"""
        main_layout = QVBoxLayout()
        # main_layout.setContentsMargins(0, 0, 0, 0)

        # --- 标题行 ---
        addr_width = 55
        dec_width = 37
        hex_width = 37
        bin_width = 75
        # addr_width =100
        # dec_width =100
        # hex_width =100
        # bin_width =100
        header_layout = QGridLayout()
        header_layout.setContentsMargins(11, 5, 0, 0)
        header_layout.setColumnMinimumWidth(0, addr_width)
        header_layout.setColumnMinimumWidth(1, dec_width)
        header_layout.setColumnMinimumWidth(2, hex_width)
        header_layout.setColumnMinimumWidth(3, bin_width)
        # 整体左对齐
        header_layout.setAlignment(Qt.AlignmentFlag.AlignLeft)

        header_layout.addWidget(QLabel("Address"), 0, 0, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Dec"), 0, 1, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Hex"), 0, 2, Qt.AlignLeft)
        header_layout.addWidget(QLabel("Bin"), 0, 3, Qt.AlignLeft)
        main_layout.addLayout(header_layout)

        # 创建滚动区域
        scroll_area = QScrollArea()
        # 无边框
        scroll_area.setFrameShape(QFrame.NoFrame)
        scroll_widget = QWidget()
        self.grid_layout = QGridLayout(scroll_widget)

        # 调整列宽(定值)
        self.grid_layout.setColumnMinimumWidth(0, addr_width)  # 地址列
        self.grid_layout.setColumnMinimumWidth(1, dec_width)  # 值列
        self.grid_layout.setColumnMinimumWidth(2, hex_width)  # 十六进制列
        self.grid_layout.setColumnMinimumWidth(3, bin_width)  # 二进制列

        self.grid_layout.setContentsMargins(11, 5, 11, 11)
        # print("hello")
        # print(self.grid_layout.contentsMargins())

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
        # self.jump_input回车后保留在文本框内
        # self.jump_input.setFocusPolicy(Qt.StrongFocus)
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
                    f.write(f"{i:03X}:{value:02X}")

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
                    # address_label.setFocus()

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

    # def showEvent(self, event):
    #     """窗口显示时更新内容"""
    #     self.update_display()
    #     super().showEvent(event)


# class ReceiveWorker(QObject):
#     data_received = Signal(str)
#     error_occurred = Signal()

#     def __init__(self):
#         super().__init__()
#         self.shoud_work = False

#     def run(self):
#         self.shoud_work = True
#         while self.shoud_work:
#             # print("Debug: Waiting for data...")
#             if serial_obj is not None and serial_obj.is_open:
#                 try:
#                     data = serial_obj.readline().decode(encoding=encoding).strip()
#                     print(f"Debug: Received data: {data}")
#                     if data:
#                         # 尝试读取多行
#                         # while serial_obj.in_waiting:
#                         #     more_data = serial_obj.readline().decode(encoding=encoding).strip()
#                         #     if more_data:
#                         #         data += "" + more_data
#                         #     else:
#                         #         break
#                         # continue
#                         self.data_received.emit(data)
#                 except Exception as e:
#                     print(f"Error: {e}")
#                     self.error_occurred.emit()
#                     break
#             # sleep(0.01)

#     def stop(self):
#         self.shoud_work = False


class ReceiveWorker(QObject):
    data_received = Signal(str)
    error_occurred = Signal()

    def __init__(self):
        super().__init__()
        self.shoud_work = False
        self.buffer = ""
        self.last_rx_time = None

    def run(self):
        self.shoud_work = True
        while self.shoud_work:
            if serial_obj is not None and serial_obj.is_open:
                try:
                    if serial_obj.in_waiting:  # 串口缓冲区有数据
                        data = serial_obj.read(serial_obj.in_waiting).decode(encoding=encoding, errors="ignore")
                        self.buffer += data
                        self.last_rx_time = time.time()
                    else:
                        # 没有新数据，检查是否需要 flush
                        if self.buffer and self.last_rx_time is not None:
                            if time.time() - self.last_rx_time >= 0.01:  # 10ms 内无新数据
                                self.data_received.emit(self.buffer.strip())
                                self.buffer = ""
                                self.last_rx_time = None
                        time.sleep(0.001)  # 稍微休眠，避免空转占满CPU
                except Exception as e:
                    print(f"Error: {e}")
                    self.error_occurred.emit()
                    break

    def stop(self):
        self.shoud_work = False


class ChatInput(QTextEdit):
    def __init__(self, send_callback=None):
        super().__init__()
        self.send_callback = send_callback

    def keyPressEvent(self, event):
        if event.key() in (Qt.Key_Return, Qt.Key_Enter):  # Enter/Return 键
            if event.modifiers() == Qt.ShiftModifier:
                # Shift+Enter -> 换行
                self.insertPlainText("\n")
            else:
                # 直接 Enter -> 发送
                self.send_callback()
                # self.clear()
        else:
            super().keyPressEvent(event)


class HostGUI:
    def __init__(self):

        self.app = QApplication([])
        self.window = QMainWindow()

        self.app.setStyle("Fusion")
        # 字号加大
        self.app.setStyleSheet("QTextEdit, QPushButton, QComboBox, QLabel { font-size: 14px; }")

        self.window.setWindowTitle("Host GUI")
        self.window.setGeometry(100, 100, 900, 600)

        self.central_widget = QSplitter(Qt.Horizontal)
        self.window.setCentralWidget(self.central_widget)
        # 分隔栏样式：灰色背景
        self.central_widget.setHandleWidth(1)
        self.central_widget.setStyleSheet("QSplitter::handle { background-color: gray; }")

        self.log_widget = QWidget()
        # self.main_widget.setMinimumWidth(200)
        # self.main_widget width 可以拉伸
        self.log_widget.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)
        self.central_widget.addWidget(self.log_widget)

        self.log_layout = QVBoxLayout()
        self.log_widget.setLayout(self.log_layout)

        # 显示过往的日志（包括接收和发送的，以及连接及断开连接的日志），不可编辑
        self.log_layout.addWidget(QLabel("Log:"))

        self.log_text_edit = QTextEdit()
        self.log_text_edit.setReadOnly(True)
        self.log_layout.addWidget(self.log_text_edit)

        # 添加发送按钮和文本框
        self.send_text_edit = ChatInput(self.keyboard_send_data)
        self.send_text_edit.setFixedHeight(100)
        self.log_layout.addWidget(self.send_text_edit)

        # 加上横向布局
        self.send_h_layout = QHBoxLayout()
        self.log_layout.addLayout(self.send_h_layout)

        self.clear_log_button = QPushButton("Clear Log")
        self.send_h_layout.addWidget(self.clear_log_button)
        self.clear_log_button.clicked.connect(self.clear_log)

        self.clear_send_button = QPushButton("Clear Send")
        self.send_h_layout.addWidget(self.clear_send_button)
        self.clear_send_button.clicked.connect(self.clear_send)

        self.send_button = QPushButton("Send")
        self.send_h_layout.addWidget(self.send_button)
        self.send_button.clicked.connect(self.keyboard_send_data)

        self.ctrl_wedget = QWidget()
        self.central_widget.addWidget(self.ctrl_wedget)

        self.ctrl_layout = QVBoxLayout()
        self.ctrl_wedget.setLayout(self.ctrl_layout)

        self.ctrl_layout.addWidget(QLabel("UART Control:"))

        # 加上横向布局
        self.select_h_layout = QHBoxLayout()
        self.ctrl_layout.addLayout(self.select_h_layout)

        self.label = QLabel("Select COM Port:")
        self.select_h_layout.addWidget(self.label)

        self.com_port_combo = QComboBox()
        # expanding the combo box to take available space
        self.com_port_combo.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)
        self.select_h_layout.addWidget(self.com_port_combo)

        # 加上横向布局
        self.connect_h_layout = QHBoxLayout()
        self.ctrl_layout.addLayout(self.connect_h_layout)

        self.refresh_button = QPushButton("Refresh")
        self.connect_h_layout.addWidget(self.refresh_button)
        self.refresh_button.clicked.connect(self.populate_com_ports)

        self.connect_button = QPushButton("Connect")
        self.connect_h_layout.addWidget(self.connect_button)
        self.connect_button.clicked.connect(self.swich_com_port_connect)

        self.ctrl_layout.addWidget(HLine())

        self.ctrl_layout.addWidget(QLabel("Set LO:"))
        # 只接受数字和小数点
        # 389.5~510.0MHz，779~1020MHz，2400~2483.5MHz
        self.ctrl_layout.addWidget(QLabel("Frequency Range: \n389.5~510 , 779~1020 , 2400~2483.5"))
        self.ctrl_layout.addSpacing(5)

        self.tx_lo_layout = QHBoxLayout()
        self.ctrl_layout.addLayout(self.tx_lo_layout)
        self.tx_lo_layout.addWidget(QLabel("TX:"))
        self.tx_lo_edit = FrequencyLineEdit()
        self.tx_lo_layout.addWidget(self.tx_lo_edit)
        self.tx_lo_edit.setFixedWidth(80)
        self.tx_lo_edit.setText("800")
        self.tx_lo_layout.addWidget(QLabel("MHz"))
        self.tx_lo_layout.addStretch()

        self.rx_lo_layout = QHBoxLayout()
        self.ctrl_layout.addLayout(self.rx_lo_layout)
        self.rx_lo_layout.addWidget(QLabel("RX:"))
        self.rx_lo_edit = FrequencyLineEdit()
        self.rx_lo_layout.addWidget(self.rx_lo_edit)
        self.rx_lo_edit.setFixedWidth(80)
        self.rx_lo_edit.setText("800")
        self.rx_lo_layout.addWidget(QLabel("MHz"))
        self.rx_lo_layout.addStretch()

        # 5px间距
        self.ctrl_layout.addSpacing(5)

        self.lo_set_button = QPushButton("Set")
        self.ctrl_layout.addWidget(self.lo_set_button)
        self.lo_set_button.clicked.connect(self.set_lo_frequency)

        self.ctrl_layout.addWidget(HLine())

        self.ctrl_layout.addStretch()

        self.register_window = RegisterDisplayWindow(self)
        self.central_widget.addWidget(self.register_window)

        # 只拉伸最左侧的log_widget
        self.central_widget.setStretchFactor(0, 1)
        self.central_widget.setStretchFactor(1, 0)
        self.central_widget.setStretchFactor(2, 0)

        # 不能压缩右侧窗口
        self.central_widget.setCollapsible(1, False)
        # self.central_widget.setCollapsible(2, False)

        # register_window 总体的边框为白色
        # self.register_window.setFrameShape(QFrame.Box)        # 方框边框

        # 加上灰色竖线 important
        # line = QWidget()
        # line.setFixedWidth(1)                          # 线的宽度
        # line.setStyleSheet("background-color: gray;")  # 灰色背景填充
        # self.layout.addWidget(line)

        self.log_text_edit.clear()
        self.populate_com_ports()

        # 按下ctrl w 或者 escape关闭窗口
        # self.window.keyPressEvent = self.keyPressEvent
        self.shortcut = QShortcut(QKeySequence("Ctrl+W"), self.window)
        self.shortcut.activated.connect(self.window.close)

        self.shortcut = QShortcut(QKeySequence("Escape"), self.window)
        self.shortcut.activated.connect(self.window.close)

        self.window.closeEvent = self.closeEvent

        if sys.platform == "win32":
            hwnd = int(self.window.winId())  # 获取窗口句柄

            import ctypes

            # Windows API 函数
            user32 = ctypes.windll.user32
            imm32 = ctypes.windll.imm32

            # IME 模式常量
            IME_CMODE_ALPHANUMERIC = 0x0000  # 英文模式
            # IME_CMODE_NATIVE = 0x0001  # 中文模式

            def set_ime_english(hwnd):
                hImc = imm32.ImmGetContext(hwnd)
                if hImc:
                    imm32.ImmSetConversionStatus(hImc, IME_CMODE_ALPHANUMERIC, 0)
                    imm32.ImmReleaseContext(hwnd, hImc)

            set_ime_english(hwnd)

    #     # 开启一个子窗口，用于显示寄存器的值
    #     self.register_window_button = QPushButton("Show Register Monitor")
    #     self.layout.addWidget(self.register_window_button)
    #     self.register_window_button.clicked.connect(self.show_register_window)

    #     self.show_register_window()

    # def show_register_window(self):
    #     self.register_window = RegisterDisplayWindow(self)
    #     self.register_window.show()

    def clear_log(self):
        self.log_text_edit.clear()

    def clear_send(self):
        self.send_text_edit.clear()

    # def keyPressEvent(self, event):
    #     if event.key() == Qt.Key_W and event.modifiers() == Qt.ControlModifier:
    #         self.window.close()
    #     elif event.key() == Qt.Key_Escape:
    #         self.window.close()

    def closeWorkingThreads(self):
        if hasattr(self, "receive_thread") and hasattr(self, "receive_worker"):
            if self.receive_thread.isRunning():
                self.receive_worker.stop()
                self.receive_thread.quit()
                # self.receive_thread.wait()

    def closeEvent(self, event):
        # close thread
        self.closeWorkingThreads()

        # close window
        # try:
        #     self.register_window.hide()
        # except Exception as e:
        #     print(f"Error: {e}")
        #     pass

        if serial_obj:
            if serial_obj.is_open:
                serial_obj.close()
        event.accept()

    def populate_com_ports(self):
        self.log_text_edit.append(blue("Info: Refreshed COM port list."))
        self.log_text_edit.append("")
        ports = list_ports.comports()
        self.com_port_combo.clear()
        for port in ports:
            self.com_port_combo.addItem(port.device)

        if self.com_port_combo.count() > 0:
            if self.connect_button.text() == "Connect":
                self.swich_com_port_connect()

    def keyboard_send_data(self):
        data = self.send_text_edit.toPlainText().strip()
        if data == "":
            return
        else:
            self.send_data(data)

    def send_data(self, data: str):
        if serial_obj and serial_obj.is_open:
            try:
                try:
                    encoded_data = data.encode(encoding=encoding)
                except Exception as e:
                    print(f"Error: {e}")
                    self.log_text_edit.append(red(f"ERROR: Failed to encode data: {e}"))
                    self.log_text_edit.append("")
                    return
                serial_obj.write(encoded_data)
                # self.log_text_edit.append(f"Sent: {data}")
                self.log_text_edit.append(green(f"Sent:"))
                self.log_text_edit.append(data)
                self.log_text_edit.append("")
            except Exception as e:
                print(f"Error: {e}")
                self.log_text_edit.append(red(f"ERROR: Failed to send data: {e}"))
                self.log_text_edit.append("")
                self.connect_button.setText("Connect")
                self.closeWorkingThreads()
                serial_obj.close()
        else:
            self.log_text_edit.append(red("ERROR: Serial port is not open!"))
            self.log_text_edit.append("")

    def disconnect(self):
        self.closeWorkingThreads()
        serial_obj.close()
        self.connect_button.setText("Connect")
        self.log_text_edit.append(blue(f"Info: Disconnected from {serial_obj.port}"))
        self.log_text_edit.append("")

    def swich_com_port_connect(self):
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
                        self.log_text_edit.append("")
                except Exception as e:
                    print(f"Error: {e}")
                    self.log_text_edit.append(red(f"ERROR: Failed to connect to {selected_port}: {e}"))
                    self.log_text_edit.append("")
            else:
                self.log_text_edit.append(red("ERROR: No COM port selected!"))
                self.log_text_edit.append("")
        else:
            self.disconnect()

    def run(self):
        self.window.show()
        self.app.exec()

    def receive_data(self, data):
        global Registers
        # self.log_text_edit.append(f"Received: {data}")
        self.log_text_edit.append(green(f"Received:"))
        self.log_text_edit.append(data)
        self.log_text_edit.append("")

        # 判断格式，是否为6个字符一行，且每个内容为5个十六进制小写数字
        parts = data.split("\n")
        for part in parts:
            # print(part)
            if len(part) != 6:
                continue
            else:
                try:
                    idx = int(part[:3], 16)
                    value = int(part[4:], 16)
                    self.register_window.update_reg_value(value, idx)
                except ValueError:
                    print(f"Invalid input: {part}")
                    continue
        # if len(data) == 6:
        #     try:
        #         idx = int(data[:3], 16)
        #         value = int(data[4:], 16)
        #         self.register_window.update_reg_value(value, idx)
        #     except ValueError:
        #         print(f"Invalid input: {data}")

        # self.register_window.update_display()

    def set_lo_frequency(self):
        """设置接收本振频率"""
        f_ref = 80

        def get_vco_divider_settings(lo_freq_mhz):
            if lo_freq_mhz > 4000:  # Up to 4GHz，使用外部 VCO
                return ("Use External VCO. Tx LO = Ext VCO ÷2 See External LO Section", 7)
            elif 3000 <= lo_freq_mhz <= 6000:
                return (2, 0)
            elif 1500 <= lo_freq_mhz < 3000:
                return (4, 1)
            elif 750 <= lo_freq_mhz < 1500:
                return (8, 2)
            elif 375 <= lo_freq_mhz < 750:
                return (16, 3)
            elif 187.5 <= lo_freq_mhz < 375:
                return (32, 4)
            elif 93.75 <= lo_freq_mhz < 187.5:
                return (64, 5)
            elif 46.875 <= lo_freq_mhz < 93.75:
                return (128, 6)
            else:
                return ("Frequency out of range", 7)  # 可选：处理超出范围的情况

        def get_reg_values(frequency):
            f_rfpll, VCO_divider = get_vco_divider_settings(frequency)
            f_rfpll = f_rfpll * frequency
            fractional, integer = math.modf(f_rfpll / f_ref)
            fractional = round(fractional * 8388593)
            integer = int(integer)
            # return integer, fractional, VCO_divider
            # print(type(integer), type(fractional), type(VCO_divider))
            # print(integer, fractional, VCO_divider)
            # print(f"{integer:04X}", f"{fractional:06X}", f"{VCO_divider:01X}")
            return f"{integer:04X}", f"{fractional:06X}", f"{VCO_divider:01X}"

        if self.tx_lo_edit.is_valid and self.rx_lo_edit.is_valid:
            tx_freq = float(self.tx_lo_edit.text())
            rx_freq = float(self.rx_lo_edit.text())
            # print(f"Setting TX LO to {tx_freq} MHz and RX LO to {rx_freq} MHz")
            tx_int, tx_frac, tx_vco_divider = get_reg_values(tx_freq)
            rx_int, rx_frac, rx_vco_divider = get_reg_values(rx_freq)
            # 发送寄存器值

            # print(tx_int, tx_frac, tx_vco_divider)
            # print(rx_int, rx_frac, rx_vco_divider)

            self.send_data(f"273{tx_frac[4:1+5]}")
            self.send_data(f"274{tx_frac[2:1+3]}")
            self.send_data(f"275{tx_frac[0:1+1]}")
            self.send_data(f"272{tx_int[0:1+1]}")
            self.send_data(f"271{tx_int[2:1+3]}")

            self.send_data(f"233{rx_frac[4:1+5]}")
            self.send_data(f"234{rx_frac[2:1+3]}")
            self.send_data(f"235{rx_frac[0:1+1]}")
            self.send_data(f"232{rx_int[0:1+1]}")
            self.send_data(f"231{rx_int[2:1+3]}")

            self.send_data(f"005{tx_vco_divider}{rx_vco_divider}")

        else:
            self.log_text_edit.append(red("ERROR: Invalid frequency input!"))
            self.log_text_edit.append("")


if __name__ == "__main__":
    gui = HostGUI()
    gui.register_window.show()
    gui.run()
