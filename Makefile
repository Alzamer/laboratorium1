.PHONY: all comp_rtl comp_tb elab run clean

all: comp_rtl comp_tb elab run

comp_rtl:
	xvlog -work lib_rtl -sv -f rtl.f

comp_tb:
	xvlog -work lib_tb -sv -f tb.f

elab:
	xelab -debug typical -L lib_rtl -L lib_tb lib_tb.top -s moja_symulacja

run:
	xsim moja_symulacja -R

clean:
	rm -rf xsim.dir *.log *.jou *.pb
