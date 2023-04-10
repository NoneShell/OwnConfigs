source /home/utest/app/pwndbg/gdbinit.py
source /home/utest/app/splitmind/gdbinit.py

set context-clear-screen off
set debug-events off



python

sections = "regs"

mode = input("source/disasm/mixed mode:?(s/d/m)") or "d"

import splitmind

spliter = splitmind.Mind()

spliter.select("main").right(display="regs", size="50%")

# 全局的变量设置
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

end
