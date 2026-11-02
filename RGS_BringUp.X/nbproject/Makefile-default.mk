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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c ../CommonFiles/source/InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c ../CommonFiles/source/power_control.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o ${OBJECTDIR}/_ext/1358597875/power_control.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o.d ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o.d ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o.d ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o.d ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d ${OBJECTDIR}/_ext/1358597875/system.o.d ${OBJECTDIR}/_ext/1358597875/mcc.o.d ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d ${OBJECTDIR}/_ext/1358597875/clock.o.d ${OBJECTDIR}/_ext/1358597875/tmr1.o.d ${OBJECTDIR}/_ext/1358597875/tmr2.o.d ${OBJECTDIR}/_ext/1358597875/tmr4.o.d ${OBJECTDIR}/_ext/1358597875/i2c2.o.d ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d ${OBJECTDIR}/_ext/1358597875/i2c1.o.d ${OBJECTDIR}/_ext/1358597875/uart1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d ${OBJECTDIR}/_ext/1358597875/Events.o.d ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d ${OBJECTDIR}/_ext/1358597875/job_queue.o.d ${OBJECTDIR}/_ext/1358597875/persist_store.o.d ${OBJECTDIR}/_ext/1358597875/flash.o.d ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o.d ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d ${OBJECTDIR}/_ext/1358597875/power_control.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/boot/application_header.o ${OBJECTDIR}/mcc_generated_files/boot/interrupts.o ${OBJECTDIR}/mcc_generated_files/boot/user_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/boot/memory_partition.o ${OBJECTDIR}/mcc_generated_files/boot/hardware_interrupt_table.o ${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o ${OBJECTDIR}/_ext/1358597875/power_control.o

# Source Files
SOURCEFILES=mcc_generated_files/boot/application_header.S mcc_generated_files/boot/interrupts.S mcc_generated_files/boot/user_interrupt_table.S mcc_generated_files/boot/memory_partition.S mcc_generated_files/boot/hardware_interrupt_table.S mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c ../CommonFiles/source/InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c ../CommonFiles/source/power_control.c



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
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/default/a7df80090497660d240f3acbec5a1db814ff95c3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/default/19d64436c412129ef082b6c7054511f0c83c1409 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/default/11280f423d9ddd1efef3543215efc25957856975 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/default/dc210eac2b429882632a74abc0b7820d05dc6c8b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/default/d1141ecce3f07e62d4007522acc2045de0b25bf7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/default/a82927efbfee286fd40d0312cd5d438245c704da .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/default/71e77d64d753322dda7e9309ae091595613ef618 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/default/c997b1a1e17d4bbc64addaa35835dd100b3f29a3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/default/f2243166fd2f4a91e943d4af7bf1be2eb6b2c02d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/default/6881ddeddace673ed89b7b0030bde1fae18418bc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/default/3f34eb6d6a20326b0de942314e41073a8456b74b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/default/e4b18ce455262d6aae16dd5872a25e602414e41d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/ce5cd14b9b72a4caeaeef3e2f5251f3ec1ea4f24 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/default/66863a8fd6f221ace72da2c71594140315c15f7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/default/bc92cacbf90d5eec91d97fcc287672cb1ec2eb9d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/default/72d90d0c0fd66195783fd1e0d9681b7ddcaa19bc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/default/e5ff726a221cb6782d78c9ecfba93de474976fff .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/default/f426d2326b957d7330d8b93e03372539561cb722 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/default/514e2ec89d5f83051d6e0bf0a199106f8855a728 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/default/cc8fb35d5e448d7ffb97ac2aee5cf1e310327e05 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/default/354332983251783bd704c17fc0dedeb0cd612003 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/default/58b815690b1d68ccede5e9b341526775d2da821d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o: ../CommonFiles/source/InitEEpromVals.c  .generated_files/flags/default/b46c2ceb2c6b9c3576d1c1aa3ecd59dcf12663a7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/InitEEpromVals.c  -o ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/default/167a19c98c26b24ac32c5a259ac534e99ae8e487 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/default/7e1d2ffc96f2a447c01a7bbb2f98ad18f4204689 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/default/fc55f2075721453b3628f501a1010a525f1a4f8a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/power_control.o: ../CommonFiles/source/power_control.c  .generated_files/flags/default/3ecec919fe3369a99d3df54a6ef3e04a71819dc2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/power_control.c  -o ${OBJECTDIR}/_ext/1358597875/power_control.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/power_control.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/default/860f2797cdfdf8c972fb721ebb6a77952e7c279f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/default/d0f28498a0440088d36211c2420614e89d3b9524 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/default/91c78d050d8276e8f6aa1d92d9ab45485cf035e6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/default/65f2ce6f6f057d0fb85f02a493ac0ce18ad18fcb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/default/312e6bbfbeeb8af05d90a4b612108fc6dfc5ef30 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/default/712b0ea4ee0c3ed33cf8ff57d426aadbb9652b1a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/default/d707a570c17443fe47b369835b6d8dba2a28a494 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/default/5817b8ca9a1cb7687fd05e310eaeb2678207459 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/default/5c166b09d4b4acd8788084d1cb4f4873e1738815 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/default/54f6400dd91d9c98ea7640982f60b2f0c7dcef7a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/default/d0d00378a7abd8f60c19d5e48043c04f75217a5c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/default/f2a3efa4e993fd04e013a7d87d39949aed1c50ca .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/c4fa0a2c0b78da9d40032fc46c31dc76207e9f3a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/default/c3d27e27300311c01fc3d99b7a3a6df4377a5238 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/default/23e6519b1444d7513453f287108af3dac16c7aaa .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/default/dab04e83de24888688d6f16e8c80d17bb4057997 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/default/a44cbffdd525acdf0a754e4ec890ccb91dfe4ddc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/default/2abfc4f23e69b0bd4b237fe1b277a88e0a3f92d9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/default/9208bc85ccd533a7e8b54657aa72e947f68cf98d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/default/58a286943f62ac2ad5d28800e33cfdc6c854dce3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/default/33172877c7675eda1f5953a6898337c00dbe45ba .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/default/5c93fc8975a2835547df4c17237ea4212d58e9e3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o: ../CommonFiles/source/InitEEpromVals.c  .generated_files/flags/default/3421bf1cd1c97c88ae3782b853be8694d2da423f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/InitEEpromVals.c  -o ${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/InitEEpromVals.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/default/4476b51f30d56ff237ca72ab710b6fa4e22b828b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/default/8a0e0f1ceaea88a91be9dfaf28ba148fa3c4223f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/default/d70bd78678ca84f71d3524aea665bf179889df4a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/power_control.o: ../CommonFiles/source/power_control.c  .generated_files/flags/default/f8115f242430655209560f43cbdb14816c8140f0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/power_control.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/power_control.c  -o ${OBJECTDIR}/_ext/1358597875/power_control.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/power_control.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -DBQ_VERBOSE=1 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
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
