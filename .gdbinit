source ~/.pwndbg/gdbinit.py
source ~/.splitmind/gdbinit.py

set context-clear-screen off
set debug-events off

python

# 默认使用 disasm 模式
default_mode = "d"

class SwitchModeCommand(gdb.Command):
    """Custom command to switch display mode"""
    
    def __init__(self):
        super(SwitchModeCommand, self).__init__("switch-mode", gdb.COMMAND_USER)
        self.current_splitter = None
    
    def invoke(self, arg, from_tty):
        if not arg:
            print("Usage: switch-mode [s|d|m]")
            print("  s - source code")
            print("  d - disasm")  
            print("  m - mixed")
            return
            
        mode = arg.strip().lower()
        if mode not in ['s', 'd', 'm']:
            print("Invalid mode. Use s, d, or m")
            return
            
        self.setup_layout(mode)
        print(f"Switched to mode: {mode}")
    
    def setup_layout(self, mode):
        # 清理现有布局
        if self.current_splitter is not None:
            try:
                self.current_splitter.close()
            except:
                # 如果清理失败，可能是因为窗格已被删除，忽略错误
                pass
        
        # 重新设置布局
        import splitmind
        spliter = splitmind.Mind()
        self.current_splitter = spliter.splitter
        
        spliter.select("main").right(display="regs", size="50%")
        
        sections = "regs"
        gdb.execute("set context-stack-lines 10")
        
        legend_on = "code"
        if mode == "d":
            legend_on = "disasm"
            sections += " disasm"
            spliter.select("main").above(display="disasm", size="70%", banner="none")
            gdb.execute("set context-code-lines 30")
        elif mode == "s":
            sections += " code"
            spliter.select("main").above(display="code", size="70%", banner="none")
            gdb.execute("set context-source-code-lines 30")
        else:
            sections += " disasm code"
            spliter.select("main").above(display="code", size="70%")
            spliter.select("code").below(display="disasm", size="40%")
            gdb.execute("set context-code-lines 8")
            gdb.execute("set context-source-code-lines 20")
        
        sections += " args stack backtrace expressions"
        
        spliter.show("legend", on=legend_on)
        spliter.show("stack", on="regs")
        spliter.show("backtrace", on="regs")
        spliter.show("args", on="regs")
        spliter.show("expressions", on="args")
        
        gdb.execute("set context-sections \"%s\"" % sections)
        gdb.execute("set show-retaddr-reg on")
        
        spliter.build()

# 注册命令
SwitchModeCommand()

# 使用默认模式初始化
cmd = SwitchModeCommand()
cmd.setup_layout(default_mode)

print("GDB layout initialized with default mode. Use 'switch-mode [s|d|m]' to change.")

end
