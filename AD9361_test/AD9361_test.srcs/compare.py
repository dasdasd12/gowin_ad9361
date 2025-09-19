import re
import openpyxl

# 读取ROM配置
rom_file = r'c:\program1\Program\2019.1vivado_project\AD9361_test\AD9361_test.srcs\sources_1\new\ad9361_cfg_rom.v'
txt_file = r'c:\Users\DDDD\Desktop\寄存器配置.txt'
output_file = 'ad9361_reg_compare.xlsx'

# 解析ROM寄存器配置
rom_regs = {}
with open(rom_file, encoding='utf-8') as f:
    for line in f:
        m = re.search(r'SPIWrite\s*\[(\w+)\]=([0-9A-Fa-f]+)', line)
        if m:
            addr = int(m.group(1), 16)
            val = int(m.group(2), 16)
            rom_regs[addr] = val

# 解析TXT寄存器配置
txt_regs = {}
with open(txt_file, encoding='utf-8') as f:
    for line in f:
        m = re.match(r'0x([0-9A-Fa-f]+):([0-9A-Fa-f]+)', line)
        if m:
            addr = int(m.group(1), 16)
            val = int(m.group(2), 16)
            txt_regs[addr] = val

# 合并所有寄存器地址
all_addrs = sorted(set(rom_regs.keys()) | set(txt_regs.keys()))

# 创建Excel
wb = openpyxl.Workbook()
ws = wb.active
ws.append(['地址', 'ROM配置值', 'TXT实际值', '备注'])

for addr in all_addrs:
    rom_val = rom_regs.get(addr)
    txt_val = txt_regs.get(addr)
    if rom_val is not None and txt_val is not None:
        if rom_val == txt_val:
            note = '一致'
        else:
            note = '不一致'
    elif rom_val is not None:
        note = 'TXT未配置'
    else:
        note = 'ROM未配置'
    ws.append([f'0x{addr:03X}', 
               f'{rom_val:02X}' if rom_val is not None else '', 
               f'{txt_val:02X}' if txt_val is not None else '', 
               note])

wb.save(output_file)
print(f'对比结果已导出到 {output_file}')