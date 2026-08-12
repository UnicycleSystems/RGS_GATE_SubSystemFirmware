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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d ${OBJECTDIR}/_ext/1358597875/system.o.d ${OBJECTDIR}/_ext/1358597875/mcc.o.d ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d ${OBJECTDIR}/_ext/1358597875/clock.o.d ${OBJECTDIR}/_ext/1358597875/tmr1.o.d ${OBJECTDIR}/_ext/1358597875/tmr2.o.d ${OBJECTDIR}/_ext/1358597875/tmr4.o.d ${OBJECTDIR}/_ext/1358597875/i2c2.o.d ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d ${OBJECTDIR}/_ext/1358597875/i2c1.o.d ${OBJECTDIR}/_ext/1358597875/uart1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d ${OBJECTDIR}/_ext/1358597875/Events.o.d ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d ${OBJECTDIR}/_ext/1358597875/job_queue.o.d ${OBJECTDIR}/_ext/1358597875/persist_store.o.d ${OBJECTDIR}/_ext/1358597875/flash.o.d ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d ${OBJECTDIR}/InitEEpromVals.o.d ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/_ext/1358597875/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/bq40z50.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/InitEEpromVals.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o

# Source Files
SOURCEFILES=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c ../CommonFiles/source/uart1.c main.c ../CommonFiles/source/bq40z50.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c InitEEpromVals.c ../CommonFiles/source/ArrayUtils.c



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
MDFUHostPath="C:\Users\peterbrewster\AppData\Roaming\mplab_ide\dev\v6.25\bin\windows\pymdfu-bin.exe"
PYFWImageBuilderPath="C:\Users\peterbrewster\AppData\Roaming\mplab_ide\dev\v6.25\bin\windows\pyfwimagebuilder-bin.exe"

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
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/714aecacdd002f349e9d49629d732d1877152a35 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/572a9b6cece7848a3bddbf31bb177d0d15a9123 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/992c92233158488c94a24ab540e84c7ca427330b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/f8de24202d8a6abbeeb98db97df4aa2c91edc7d2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/bf03da28f28adf84d1dfcd5d460c78f1420a537b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/eac722e6ca462342986fe23b05f98e15e1c1d38c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/e04cd572be3382d546c52ad917f494a8cf9fc42 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/c19dd483f0f443be5ac456c5ea9fcb1526031a79 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/cba0a98009790c6124333bda410a58993f3271ea .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/62ede1f4f072ed47f467287cad39b9a596f7803a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/8b48b25d07447221626b49e72b2c58187ab4cd57 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/standalone/33bf318ea831232ad44f68fcad8aebd4bf9ab51d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/cf41c9652438b690a66009199a3baf82e659c874 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/standalone/55385f540b3ca65677338c38c0739ae049349d7d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/46f9df9dee24f3b04417beecb939f1cc61285462 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/61dce31b95dc2aee428179932dc1a8805ef8afb4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/9695820ad10df6654c98e8fef9950f0871eaa24e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/8f43d3b8bf02e7735d67c16b3e3af6084ef38325 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/ca31e38706a9c059bc83636a5e7d948a58d48977 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/7a334f81fa4bb920b672b9917215bb8dded7f4cc .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/953144b000b981218dba5c46047f0d2c11f73027 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/d5bf3baa94716a952282f504837efd408c62a3fa .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/standalone/9e009df2fe4652e14beee3b90da6a7a92fc3c255 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/7e30d2a7bc33d9f11f731f97be5bf38af34c1f3c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/b74ba66489fe5964769b834158bd23e81fc79965 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/6a02080f65600574385c1f001712402d9c615a1b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/661c950e307daf5369e723ab912da6c5c07d4427 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/e54cb1db6fbd3e8670d3a0b5383f81a50c534714 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/dc814d523d71001b72cf1cb0d5a2e3e777373b26 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/e409dd2f3d480f54dc983bf6e68cd5f362cc968f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/b7c6487d1deabea17d2eed5669307387496a28e4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/efc8367308277afffe38e6c9c2c1dfd9076f79b8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/b77df5c201a7a68526ad69659552251c8354b8fe .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/9f64125b46043c92589ee8fb4150ff6bf69fdbe5 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/6efd86c9ea169dc8bbc6b3a7a7c1d0a91b6a8edf .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/uart1.o: ../CommonFiles/source/uart1.c  .generated_files/flags/standalone/5208528273bbd6469c3b93f2c8013569a6609878 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/uart1.c  -o ${OBJECTDIR}/_ext/1358597875/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/uart1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/2058bb1eb5485d97b15c212a47b9611c9358279a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/bq40z50.o: ../CommonFiles/source/bq40z50.c  .generated_files/flags/standalone/fbc030df44469e68520610b4c45d817c41f05e79 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/bq40z50.c  -o ${OBJECTDIR}/_ext/1358597875/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/bq40z50.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/a3ffc546468df96ef676c9612341828029381f06 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/8ded24f4aa03a52f1ca6497ea50677205d1b5aa8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/fce82edbaae63e65dbe429bbbdbee271932a8cb1 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/ca7dc779b4c2243cc9a714074550b8c40888a631 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/58735a5fd67614fe69063a95734a9b822b36e95b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/2895e111761cfebb59c942730cd843812ea01d43 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/63bfb2ee7eb52cc44719f5c49753cd0f8e79aa6c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/86270f0185dec0ae1a5e59a6c65aec908b24495e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/InitEEpromVals.o: InitEEpromVals.c  .generated_files/flags/standalone/828157cafd4232dd79b5a006fe0aaf366efc3a26 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o.d 
	@${RM} ${OBJECTDIR}/InitEEpromVals.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  InitEEpromVals.c  -o ${OBJECTDIR}/InitEEpromVals.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/InitEEpromVals.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/1e997cb56d9c8fff22a9c1a01443f7d80eeb186c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/f0f150e25ffe4e206ca7a6d29e786588c3c88a75 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/1ac91bf07b508fad11b1f0633701161e7c418ce7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/6dc6896e86560d9bad82368fb4e0a7dfadcf81ed .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/23fbc558d3ced9bbc6fc27bd96b299eb780d8f60 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
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
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
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
