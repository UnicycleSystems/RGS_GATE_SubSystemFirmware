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
ifeq "$(wildcard nbproject/Makefile-local-standalone.mk)" "nbproject/Makefile-local-standalone.mk"
include nbproject/Makefile-local-standalone.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=standalone
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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d ${OBJECTDIR}/_ext/1358597875/system.o.d ${OBJECTDIR}/_ext/1358597875/mcc.o.d ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d ${OBJECTDIR}/_ext/1358597875/clock.o.d ${OBJECTDIR}/_ext/1358597875/tmr1.o.d ${OBJECTDIR}/_ext/1358597875/tmr2.o.d ${OBJECTDIR}/_ext/1358597875/tmr4.o.d ${OBJECTDIR}/_ext/1358597875/i2c2.o.d ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d ${OBJECTDIR}/_ext/1358597875/i2c1.o.d ${OBJECTDIR}/_ext/1358597875/uart1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d ${OBJECTDIR}/_ext/1358597875/Events.o.d ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d ${OBJECTDIR}/_ext/1358597875/job_queue.o.d ${OBJECTDIR}/_ext/1358597875/persist_store.o.d ${OBJECTDIR}/_ext/1358597875/flash.o.d ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d ${OBJECTDIR}/InitEEpromVals.o.d ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o

# Source Files
SOURCEFILES=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c ../CommonFiles/source/i2c2_helpers.c ../CommonFiles/source/lis2dw12_i2c2.c



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
ConfName=standalone
ImagePath="dist\standalone\${IMAGE_TYPE}\RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\standalone\${IMAGE_TYPE}"
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
	${MAKE}  -f nbproject/Makefile-standalone.mk ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: [.${_/_}deployHex$(ShExtension) ${ProjectDir} ${ImageDir} ${ImageName} ${ConfName} ${IsDebug}]"
	@.${_/_}deployHex$(ShExtension) ${ProjectDir} ${ImageDir} ${ImageName} ${ConfName} ${IsDebug}
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/ebeaf66398163c0efcf1b133927f8b8b5153ca95 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/5e6d9021091e6cdf87cf793f2471736eb4ee347b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/197c47664fd61163b82ca329c7e229bd2c4b9edf .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/34b4f4fea9ea3c21b0a1a903574bfb8d0274e1c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/957791c029e602a57fd275a3d8c79a5515458705 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/9c992fc9138cd304581fcb9e2a51aad0b469e4dd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/b6b8aa8f171fea89b1b1b78310d37b53adcf441f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/d5847578418dfea8199f0e2c0603ebdc412487b3 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/652956ab09d56c3eabf8e7a1aba19487d09037ce .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/6f28b29edbdbd04012e3338e72352597488e4c9e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/225b5eaedc0cb4caebf1a0a2631b6ac28e12eea1 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/standalone/e7071a975f2ae4f2253790bee745f3986b11b7bd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/d3adcf7ed6d2f983231f5e12df40d2ea68600cbb .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/standalone/73713c3335caa063a6ea3b99fd7b1a9a6f0548c8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/35ba4785775ef4d1369559501895ec0dd3853d88 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/8363f2030692fa999ff579b16435e4253b5c3d66 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/eeb2389039a17d04270d0766267d1ba7bd147a3b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/aba398897610e15ae96ec909e200e5f0baeaf1fa .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/d868aad19f8fc1b1619047b0d9957bcd33d04dc9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/dc50ad1ec0a040982abd773eea27c837e88da375 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/f49c89881325a9466a510ed3aaba815f5c2bb90e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/f78df0a59ecae008a0a0e37cfc5d09e6590460a9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/standalone/c3350482b5aed3a59118ea9adf270b2e42b876d4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/5bb89a4b0d30e88297529d9bf3bd14c3756e6472 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/standalone/88ab149ad0df4f9cb80866435d5114a8c7ae7e0e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/standalone/561c728fe65afa5feb77c7dc51866c9dc27dd8c6 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/23fe32de4200559c83ebfbc002ba80b680137481 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/7e09f608bc5f49c690b7ac3dfe2989431261a6ea .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/5f3dd3714d88ad3b55c85f4c160cf4d0514c51c9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/2bc94244860c8e4283b0d8a4501002b438319cdd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/6af54040e829323ad9574813cf4d74262add4882 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/d0aff1a4ba3b9a41d0ce2fcb9cb34ed8062c4e9d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/ea65ad04cb1902050958f825668677e319a92750 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/c5b85745377970d5acfadd24fd412694fce3c9ce .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/55670b04436d8b3859bde79b81738597099f6ed3 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/1ec06bca599e9260621509e5c49af3ba4f3f9d83 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/8fd6dc2ebd9ee4f2ce02996ca6d2b7a872287d24 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/standalone/4b3a72681eec09e5377b331a517e227526f3f167 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/2058bb1eb5485d97b15c212a47b9611c9358279a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/standalone/d8eac5438762bdf18ac86aeb01e656f4d6cb4ba2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/a779727e3d95ddbca211d831a1ef28db8b028cf9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/b58e27ff07d59c8835e9c0ade6c6dd29d3641450 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/79ec2d40c6d2e270b7f2cbce208b3884f674c493 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/97b7528247e749530c615d4a50cce8067946e401 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/ee411211208f19d696e19d706df513cd09c09d0e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/dd47d0717119698a2042776deb0de35ca18e904c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/e885f804513fe07c14c8bce78c589c66247e5dbb .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/bfd09619883cb9d654845d0238540500834aa957 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/standalone/828157cafd4232dd79b5a006fe0aaf366efc3a26 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/7ad734afb56a0344bc525013decf679cbe7139b7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o: ../CommonFiles/source/i2c2_helpers.c  .generated_files/flags/standalone/f4d07791a5d37102cadade995b52bcfdbb47fdee .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2_helpers.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2_helpers.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o: ../CommonFiles/source/lis2dw12_i2c2.c  .generated_files/flags/standalone/5354343ce7cea42ea99c59b1ced527f479e4f416 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/lis2dw12_i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/lis2dw12_i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/e96296ebc44f5d6f4bd9c27808ea9b73ac08f0d2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG   -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/f339ad089578b971d2683621a1c186434d0e64be .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG   -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/6dc6896e86560d9bad82368fb4e0a7dfadcf81ed .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/cf79bbb60eb7bef9ef8aa9008af99be7e092962c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG   -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
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
