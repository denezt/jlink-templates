JAVAC=javac
# Output File which stores modules
OUTPUTF=output_src
PROGNAME=SimpleProgram
BUILD=jruntime
JRUNTIME=/jruntime/bin/java

all: clean build test
	@printf "Executed all build steps\n"

clean:
	@printf "\033[35mRemoving module files\033[0m\n"
	@printf "\033[31m"
	@rm -rfv $(OUTPUTF)
	@printf "\033[0m\n"
	@printf "\033[35mRemoving Jlink files\033[0m\n"
	@printf "\033[31m"
	@rm -rfv $(BUILD)
	@printf "\033[0m\n"

build:
	@printf "\033[36mBuilding Modules\033[0m\n"
	@$(JAVAC) -d $(OUTPUTF) src/module-info.java && \
	printf "\033[32mDone!\033[0m\n"
	@printf "\033[36mCompiling Sources:\033[0m\n"
	@$(JAVAC) -d $(OUTPUTF) -modulepath $(OUTPUTF) src/com/opensource/software/$(PROGNAME).java && \
	printf "\033[32mDone!\033[0m\n"
	@printf "\033[36mBuilding Minimize Runtime...\033[0m\n"
	@jlink --modulepath /usr/lib/jvm/java-9-openjdk-amd64/jmods:$(OUTPUTF)  --addmods java.base --compress=2 --output $(BUILD) && \
	printf "\033[32mDone\033[0m\n"
	.$(JRUNTIME) -listmods

test:
	@printf "\033[35mShowing Dependencies...\033[0m\n"
	jdeps -modulepath $(OUTPUTF) -s -m simple.program
	.$(JRUNTIME) -verbose:gc -modulepath $(OUTPUTF) -m simple.program/com.opensource.software.$(PROGNAME)
