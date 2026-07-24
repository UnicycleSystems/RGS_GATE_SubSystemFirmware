#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c main.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/system.o.d ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/Events.o.d ${OBJECTDIR}/JetsonInterface.o.d ${OBJECTDIR}/pin_CustomISR.o.d ${OBJECTDIR}/i2c_write_queue.o.d ${OBJECTDIR}/address_block_lookup.o.d ${OBJECTDIR}/job_queue.o.d ${OBJECTDIR}/pitchandroll.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o

# Source Files
SOURCEFILES=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c main.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

# The following macros may be used in the pre and post step lines
_/_=\\
ShExtension=.bat
Device=PIC24FJ64GA004
ProjectDir="C:\Projects_Firmware\RGS_PuttingGate.X"
ProjectName=RGS_PuttingGate
ConfName=default
ImagePath="dist\default\${IMAGE_TYPE}\RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\default\${IMAGE_TYPE}"
ImageName="RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IsDebug="true"
else
IsDebug="false"
endif
MDFUHostPath="C:\Users\peterbrewster\AppData\Roaming\mplab_ide\dev\v6.25\bin\windows\pymdfu-bin.exe"
PYFWImageBuilderPath="C:\Users\peterbrewster\AppData\Roaming\mplab_ide\dev\v6.25\bin\windows\pyfwimagebuilder-bin.exe"

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: [cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir}]"
	@cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir}
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/default/f7f5acdff774fa18a40530737dc091349e53a9bc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/default/1bcb41cea4e48c90cea82810bf5cb988e8bdf095 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/default/132134a7f05e6a9858208161ea8fd585c4dd4e2f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/default/3c825c3dec14d8e9dd0d4ec5ab38672d2f20fc22 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/default/d06529df3fc0c061db694a0afcee9b1038f24e03 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/default/6d4035344a100a5517a104e6d02d297ffd7067bc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/default/880f03e170181af5ab0113f70fc444e65d3e7e13 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/default/dda0bad32431323bd9c2470f9e20c9db5b1ce20d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/default/bdef1e55246ad730f6a686b2992ed4add5ec2e1c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/default/322b185f23490775618de766f62aa5b4cf741eb5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/b4613df4b2a171ac66480e7fa0eda8a20093c1f3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/default/38f62ce00dbe3efe4fc090268363cbeb8cecdf70 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/default/b08947f89447854e66a3fe4a3c72a681a6adeedf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/default/f276aa87fe2b9a4df0d55b62f917b33ac6a72ccf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/default/a0e186ebe4a56b43928965b43c5f5e3c78e0ea55 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/default/466c30cc7cade1913a19c7d2c51d25620f5e3c72 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/default/1377f0a14b7cfc21ce0f8aba84fcc25c67ff12af .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/default/543ba70bbc3ab9623a03ddd6237a32aa932fbabe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/default/2c67951c373a72f7dddbc965fbb2e8a014587f7d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/default/f966d52e0479d974f35b6dda6d32d6c3a8329e5f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/default/6e4b96bcf0567ef43f678c46f6bfea5817cb097c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/default/3471ed228a50bdcd0b6cb1ec97b6a4947c67db65 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/default/2b7cd260081c76197b2dae223593b0868b273466 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/default/7b1f79568cfaac8a526e35292bdf675836c96b25 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/default/46893f0dda60d099509cb3080f5da85e91ff24bf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/default/10624c5a7cb29208374f28b167e7c3834102beb4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/default/7c55912a26e8b8e2aed27a7c00e527d832b33484 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/default/86918326dcf385a685999082c400516d8894c3c1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/37decd4a83b51463b521d7923222b24596cd97a3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/default/f0a8fec321c6d65834f410e4d01ab15a18cd642f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/default/5c1882282d2938e1bb0143505e56ca16e30b6430 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/default/446c2c20d583a296e5df8cf2cbc94de57ff1a027 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/default/f070b927ac844050744c3a657c6b3ec1d0424f87 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/default/bf5515c579f8bf48bcbee357565f1d80238e8594 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/default/d44c21e404ad17d47aa3ffc9a67ab7fa6fe3fb9c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/default/d74bc0059e6c7ebe032abe99d7673fb35fe7140b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/46a0a49007c6436d7f7258c59a891695f78c6419 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/2f8f26535deec7f995c2f2947c7d9762d8b709da .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/d243b9551a4bc1e5844240a86071e87ddd8f7690 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/633d2cbb0a749c31860ec4be80245e6ce03d0518 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/45fe4b497badd7460c8507c26816bd337b2eb6df .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/c8878ec8895a59bdac8d2f7d932352fb9ed5c34e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/60b24bd68169448f15d8a3f16aa156657e791e3e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/bd1cef9dbce090f8ba8ae7f299b70555e50abc01 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/2c0eed84ea0cf9e93a7f7a45837612b8be46de27 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/e1231d19c7b97acd8b9a1cd34e9cda81629c5cef .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/9cf5255f5ed556c9fa1d5c9929da1db3be3dbc06 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/19772960e377f1d6298354e787e59279f90bb043 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}\\xc16-bin2hex ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
