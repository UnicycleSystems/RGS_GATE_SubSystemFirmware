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
FINAL_IMAGE=${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
ProjectDir="C:\RGS_GATE_SubSystemFirmware\PuttingGate.X"
ProjectName=RGS_PuttingGate
ConfName=default
ImagePath="dist\default\${IMAGE_TYPE}\PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\default\${IMAGE_TYPE}"
ImageName="PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: [cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir}]"
	@cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir}
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/default/8525490d7c069dc9bc057ea4ce46e4774fe1d7bc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/default/d3072f8da88ecf6626ce42028af678327cacbb59 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/default/39d8b79c55172cd74e24452a6d76b7245b0e0146 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/default/d63d0b614a555dea54ee45f0a8c6cd079935cae .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/default/65be67ffbda6a92e9e24c1f8c5b488278b6b1587 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/default/a00fb895764bb2705fd6b5c7b1ab50562ce9b437 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/default/bb096a9fe23991d472e2706d0fcab23098769e63 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/default/8ddfdcc9acf7d78d53788dd145c4412c8e3e20ed .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/default/c71b5ed45159acc4eea82fe41c64f164820101cf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/default/6fb8463f2cdd8283e803a09572dbe0d1667f3d06 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/695ae95e3b23d69077a14d21ab7c239120022898 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/default/6198228c07bd580d6f694f4d7988b26696bfecc9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/default/80ef218b815309e475ba49aa33386959f0498e1f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/default/14ecc4a2701ae4596240712f6fe8243d0daba93 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/default/1c89bea725c14d4bd36aef5790826bcdec1c479c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/default/84f71fd29b5d6573ef0eea90a39f86dc096cdaa7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/default/2eaf2f5c171ee42c04453b13643a9704e09b4de4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/default/8cd032165a7b77d740574fc51440f5fbdc42f50c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/default/574a261f0a0974bdb8b2ec251af0eee1b0f3c716 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/default/2c94127431b2f0f0e4158dab13af0c6fa3816d33 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/default/9abce4ab8d321dd54ab8cf3876e1f10dd9764c59 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/default/9032ef15056168cd37a7aec50ec1453ddc8055b7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/default/3ae08a290082a798276a555b0a9b230516032105 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/default/fc8d218159855bbaed25bb2806e0bb9b651dfd02 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/default/249351e0ed0247c1043e1ddd60f268df8ce9cba5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/default/2527aec553400ce11b5ca9c8b53bf2f10dad9eef .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/default/34ccadadb848d2088f1ba777a8ddb6efdf4363b4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/default/f52e98e0a6555f11e4d8c9469c64e0920a0fcb23 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/7bbe7c790d3f65908a1d69a1d6f4cb62b9bcb2e6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/default/8701eb3a001d5c36d9406dcc1d7111f101d5ca29 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/default/c91314f5d9105cfe1306ac75b873928f67100323 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/default/cb221401f7fd45816a5ad9805105359190f29c43 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/default/5ce4328dc0ef76bcab7eb90b9ebd16c016db4d6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/default/cdc5e80d59dd1ccb0b9bdd842377b8624cdfd074 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/default/700ab1922f243ac4fc7fa5e6f8f53e5dabfaf366 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/default/fc760b5d5a1a0b176c39f947f6a802e2faaba5f0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/9e3839d262712b92a1305007d0922d7990a28198 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/3a3b14ccf333faf921ffecf85a335db85ed33fdc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/3ff8ba66c2f5148c464cc7cee6561219564d03bf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/e465fb377da492e7557ba94b5f546def9f8ba243 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/14a771c377fedd0c87db177352236b1c5834010f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/aafaab5b808f91a685fa12832b9a6e833c1295b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/ca348bb47091df427f600345359928d8fb4a0270 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/aafb8a55af396201a880aa3aae8623d63c265e03 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/258c56656b13b5d861eb244df5610a49c4cb8549 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/3c899ff10017754d9474783d59d29b9522a07732 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/b249b3ae4630536ac2dfee869270712305e4362c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/26c574dcfb6be61967a26b6d7a2dbe8d0120cf1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}\\xc16-bin2hex ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}
