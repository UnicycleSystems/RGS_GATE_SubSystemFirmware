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
FINAL_IMAGE=${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c ../CommonFiles/source/power_control.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o ${OBJECTDIR}/_ext/1358597875/power_control.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d ${OBJECTDIR}/_ext/1358597875/system.o.d ${OBJECTDIR}/_ext/1358597875/mcc.o.d ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d ${OBJECTDIR}/_ext/1358597875/clock.o.d ${OBJECTDIR}/_ext/1358597875/tmr1.o.d ${OBJECTDIR}/_ext/1358597875/tmr2.o.d ${OBJECTDIR}/_ext/1358597875/tmr4.o.d ${OBJECTDIR}/_ext/1358597875/i2c2.o.d ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d ${OBJECTDIR}/_ext/1358597875/i2c1.o.d ${OBJECTDIR}/_ext/1358597875/uart1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d ${OBJECTDIR}/_ext/1358597875/Events.o.d ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d ${OBJECTDIR}/_ext/1358597875/job_queue.o.d ${OBJECTDIR}/_ext/1358597875/persist_store.o.d ${OBJECTDIR}/_ext/1358597875/flash.o.d ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d ${OBJECTDIR}/InitEEpromVals.o.d ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d ${OBJECTDIR}/_ext/1358597875/power_control.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o ${OBJECTDIR}/_ext/1358597875/power_control.o

# Source Files
SOURCEFILES=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c ../CommonFiles/source/power_control.c



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
ProjectDir="C:\RGS_GATE_SubSystemFirmware\RGS_BringUp.X"
ProjectName=RGS_BringUp
ConfName=default
ImagePath="dist\default\${IMAGE_TYPE}\RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\default\${IMAGE_TYPE}"
ImageName="RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IsDebug="true"
else
IsDebug="false"
endif

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: [cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir} && .${_/_}deployHex$(ShExtension) ${ProjectDir} ${ImageDir} ${ImageName} ${ConfName} ${IsDebug}]"
	@cd mcc_generated_files/boot && .${_/_}postBuild$(ShExtension) $(MP_CC_DIR) ${ProjectDir} ${ImageDir} ${ImageName} ${IsDebug} && cd ${ProjectDir} && .${_/_}deployHex$(ShExtension) ${ProjectDir} ${ImageDir} ${ImageName} ${ConfName} ${IsDebug}
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/default/f60b9ee46404f53b1c4adb30db9ce5b90118fa52 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/default/d9f1de0b0f68b81017edabffdf1e29ddbaf6e31f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/default/319fac89456db099011a210619ab50a19933ee7c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/default/d23b4d584965f328899cf8cc4613c9aa1d1696a3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/default/729db7fa825f273c19ee7bcf5c31ad2c37f2918f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/default/bd63f59788cce3c33e7defe36a353459ba201714 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/default/360f94dda5d4201e3437573c86a57b26e0039285 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/default/1a0d4118b98a6550c51e0168387555488fc3b34a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/default/7466625e6d8721c78d756ed3d58480967cad1651 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/default/6912257d88d99f699de8c98e8bfdbb1bc8f6986b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/default/aaf8335f2798380c9cd02852186cf782319d86cb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/default/f2a593e05a433679be9428b58793da4551cd43d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/65c74c0262e2045a60e8a1e4bbe788b86e54fec .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/default/23b08492cb6566a9e5bea57ee7054a537abbd4c9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/default/2ab076c006b5e16b3134143493c0012fe8a8b57e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/default/37823dc924c7dd5904722e3517c079fec254bc50 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/default/a01df433039f4b9586fdd97228893bb189f81dec .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/default/8c317610fe02172362af9db0bfb781517a5b16a7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/default/fe4d493bd177df99d7a0eec3cfd7d4f7caf281e9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/default/ee5938ac9ff2b88fd1ef6712dd9658ed1b931f75 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/default/28104fcb45c0d7f29c1a3d37d041c52da004a79e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/default/cdb3fe26694e13b34de1bb213bfe90b1dc3b34a5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/default/718eaa75dc6d349d49a3c4d52bbd8c50fe8d8e2d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/default/b0080339cd50677c84d39f4d33c9e3847ee33a2c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/default/e2684826804b61902c1b0ecd066149035ace2742 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/default/264ef2b0173f483922fd17cfab754b801cc3146d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/power_control.o: ../CommonFiles/source/power_control.c  .generated_files/flags/default/39c6f04c0261041d81cfaf97c052144d349f7669 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/power_control.c  -o ${OBJECTDIR}/_ext/1358597875/power_control.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/power_control.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/default/84b9fe03cc8d5e57ca3323ad4060b9695ada8a7c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/default/8609e1b95203b7b8f34f3057becc0931e3087159 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/default/2137bb713f2de58b5d1a373cc6904d565db0bf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/default/1aa02dc67daf1d1259fdc4730f4ada9961c8048b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/default/25f894a4a3f2e90689d0a493653f56fb16074dc8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/default/be06495b6813191a5cd360d523d2ea797b4eab37 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/default/9a57b084208ad6b09b2688139a6915158d767bbc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/default/976cc0196d2c5c1abb1fe19f3b184fe0486072c8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/default/e21877810a322921ae4a89143398b7c74b32b3df .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/default/27ca4ef1d0b7baaf560c3fbb81669c2a82f37aa1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/default/29642e2db48f1284764b660aaedeffb717b3c839 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/default/8ad957019cac54ea983df33e698df53b0382dd9e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/87b645d2cb9308650c49ba582f01b6f097a2a598 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/default/8484d0492ff75b987c02825cd3a65abd8ed20baa .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/default/ab0d8816aabe0aacd28965f1cd0a838f47a66d22 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/default/73f9b1219edb2422d9e3f73b56af9b76d856096a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/default/8ae57de4ffd9e91d53587900e879e0b5156a8d7e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/default/bbd41b043137d9ea3aa1b6e6ded3d3f28f3f74bd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/default/616f3ff941ab3f2434125b419442dc02981da8a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/default/68e3ddbe12dffa61084bee1ae9a35c8c2a7d1fba .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/default/c585c0591a2e62a1c8dbe21f1aefd9064b3dceb9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/default/98a4bed371667c83e4e3198ce79fa879edd69187 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/default/b23342683e54140553638f059a76070e174916c2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/default/2bfda6339a7ce8d4e7f3db12ca55a7ce36b639e6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/default/f2a27c3936914a5787685d319d2be00150f78856 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/default/1d33b1928993f251ec99ce145df09e7b2ae8fff1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/power_control.o: ../CommonFiles/source/power_control.c  .generated_files/flags/default/fe7b968e39df9712626c6810fb833769bd1a0524 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/power_control.c  -o ${OBJECTDIR}/_ext/1358597875/power_control.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/power_control.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/1c5860c447db9f24cd55b1fb83e7cf39a51a0b08 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/default/8d7dac28750a63e966b43813e3516871aa32d526 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/default/a9a49e35cd73afa314b695e21130a94a4115be1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/default/b740087c208b73cf1131b573703d9b4f30edc58b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/4dc23fdaeb8bc0cb29fbef5ec1e6e0f06ef58700 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/ee75b63dda47dd5334b7a87f100fb10bee11c176 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/d956d32a2fc59618945f563211cf2c3840761870 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/bf5dab4f1304648350019a69a88cadc0f720a954 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/24d7cc476875db02bc6c17782205d42bfa7e6300 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -D__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/boot/application_header.o: mcc_generated_files/boot/application_header.S  .generated_files/flags/default/d97f16a0f022782a4f8912ef5dd72598a4ff00e1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/application_header.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/application_header.S  -o ${OBJECTDIR}/mcc_generated_files/boot/application_header.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/application_header.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/interrupts.o: mcc_generated_files/boot/interrupts.S  .generated_files/flags/default/1fef7838b74e4e71f6397b41d909464952fac1db .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/interrupts.S  -o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o: mcc_generated_files/boot/user_interrupt_table.S  .generated_files/flags/default/cffcb1a0d1f614621726024e8b24cd85ca34c44b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/user_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o: mcc_generated_files/boot/memory_partition.S  .generated_files/flags/default/1ebc365b66f3f957c807fefabdf4ed0d50fdb428 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/memory_partition.S  -o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o: mcc_generated_files/boot/hardware_interrupt_table.S  .generated_files/flags/default/ace7ec9fcf432f7fad33bc397d9d2b2348539a24 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files/boot" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/boot/hardware_interrupt_table.S  -o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d"  -omf=elf -DXPRJ_default=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}\\xc16-bin2hex ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
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
