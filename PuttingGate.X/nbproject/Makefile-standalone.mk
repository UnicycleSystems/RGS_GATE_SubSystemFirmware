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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c main.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c ../CommonFiles/source/ArrayUtils.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d ${OBJECTDIR}/_ext/1358597875/system.o.d ${OBJECTDIR}/_ext/1358597875/mcc.o.d ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d ${OBJECTDIR}/_ext/1358597875/clock.o.d ${OBJECTDIR}/_ext/1358597875/tmr1.o.d ${OBJECTDIR}/_ext/1358597875/tmr2.o.d ${OBJECTDIR}/_ext/1358597875/tmr4.o.d ${OBJECTDIR}/_ext/1358597875/i2c2.o.d ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d ${OBJECTDIR}/_ext/1358597875/i2c1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1358597875/Events.o.d ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d ${OBJECTDIR}/_ext/1358597875/job_queue.o.d ${OBJECTDIR}/_ext/1358597875/persist_store.o.d ${OBJECTDIR}/_ext/1358597875/flash.o.d ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/_ext/1358597875/pin_manager.o ${OBJECTDIR}/_ext/1358597875/system.o ${OBJECTDIR}/_ext/1358597875/mcc.o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o ${OBJECTDIR}/_ext/1358597875/clock.o ${OBJECTDIR}/_ext/1358597875/tmr1.o ${OBJECTDIR}/_ext/1358597875/tmr2.o ${OBJECTDIR}/_ext/1358597875/tmr4.o ${OBJECTDIR}/_ext/1358597875/i2c2.o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o ${OBJECTDIR}/_ext/1358597875/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1358597875/Events.o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o ${OBJECTDIR}/_ext/1358597875/job_queue.o ${OBJECTDIR}/_ext/1358597875/persist_store.o ${OBJECTDIR}/_ext/1358597875/flash.o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o

# Source Files
SOURCEFILES=mcc_generated_files/where_was_i.s ../CommonFiles/source/pin_manager.c ../CommonFiles/source/system.c ../CommonFiles/source/mcc.c ../CommonFiles/source/FrontAlignLaser.c ../CommonFiles/source/clock.c ../CommonFiles/source/tmr1.c ../CommonFiles/source/tmr2.c ../CommonFiles/source/tmr4.c ../CommonFiles/source/i2c2.c ../CommonFiles/source/interrupt_manager.c ../CommonFiles/source/i2c1.c main.c ../CommonFiles/source/Events.c ../CommonFiles/source/JetsonInterface.c ../CommonFiles/source/pin_CustomISR.c ../CommonFiles/source/i2c_write_queue.c ../CommonFiles/source/address_block_lookup.c ../CommonFiles/source/job_queue.c ../CommonFiles/source/persist_store.c ../CommonFiles/source/flash.s ../CommonFiles/source/pitchandroll.c ../CommonFiles/source/ArrayUtils.c



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

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-standalone.mk ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/bd922e0757bfb06f7fcc9edeff7392c193b365f9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/37b273c6c66f9dbd4cd720563e83037ee29c7520 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/59103de8dd15d494f10fd0aec0baafb3749abcb8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/376c8f648e62ff0b92f4a63ff91f8a8dcc0c32d4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/d520e4a19a24d955aac90442be26f4878b06a895 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/a33aac9284555608a9a9fc63f38abc806cee1a56 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/bfc9b952c7410eb95e6ccaf66e33787be53df78d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/fc8c9e2bba3261dabe5075fda5852ddd68992091 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/77a5b43205540b34e6bbc1a3bf082c5945b12a53 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/1b6c0281a0e9c4b1f2dd20925ee9388aed49a0d5 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/272e836895b638e6cc26ff307057a4a7db3661a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/ed35280cd92e6df08641e66088effcbe5bb3d769 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/58121eb658526bedd840c829ccd675d0f564307a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/d752bf93ade81c5003e26276f7c766b9cb87994a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/e65e283c890477d835e646e5bbbf5c7ce4c33be0 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/60498d0ce886bd72b9d84e3b88c8108fdebaadc2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/a144fc377d0b173dac885fe70c9254db5d835660 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/6e8303377761823bc570b37cd44c33c04ba8a63e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/ace8272f02213f7f67d0a37c097356a995626acc .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/4563a27742150d1d28d3cbb3463619569b72573c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/7e74c38865eb93455e3facddea88ade2abccaba8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1358597875/pin_manager.o: ../CommonFiles/source/pin_manager.c  .generated_files/flags/standalone/6830a334f93d7ceb257a48f07290145c78d0ac98 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_manager.c  -o ${OBJECTDIR}/_ext/1358597875/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/system.o: ../CommonFiles/source/system.c  .generated_files/flags/standalone/401391dd4bb6c1c3d48888005719934bf530125d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/system.c  -o ${OBJECTDIR}/_ext/1358597875/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/system.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/mcc.o: ../CommonFiles/source/mcc.c  .generated_files/flags/standalone/37e284522b3ff21ac710c1b42b71a7cc1d2ecfb4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/mcc.c  -o ${OBJECTDIR}/_ext/1358597875/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/mcc.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o: ../CommonFiles/source/FrontAlignLaser.c  .generated_files/flags/standalone/524646ce6da7e690394bc18ebf252cebd16da8aa .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/FrontAlignLaser.c  -o ${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/clock.o: ../CommonFiles/source/clock.c  .generated_files/flags/standalone/eb26317f7eb341acc4e1b46433ee7c02fdd6253f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/clock.c  -o ${OBJECTDIR}/_ext/1358597875/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/clock.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr1.o: ../CommonFiles/source/tmr1.c  .generated_files/flags/standalone/1fa51c7f343fd4db9359076739dddc8737bc9519 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr1.c  -o ${OBJECTDIR}/_ext/1358597875/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr2.o: ../CommonFiles/source/tmr2.c  .generated_files/flags/standalone/777ae4af8ba41213a4b83c94a2025c70033afe42 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr2.c  -o ${OBJECTDIR}/_ext/1358597875/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/tmr4.o: ../CommonFiles/source/tmr4.c  .generated_files/flags/standalone/5c7e6bd390084e072c9928f65b3e7a655007ec1e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/tmr4.c  -o ${OBJECTDIR}/_ext/1358597875/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/tmr4.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c2.o: ../CommonFiles/source/i2c2.c  .generated_files/flags/standalone/614a6d547c2a76b6553e9bca8f54ca01684f7b46 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c2.c  -o ${OBJECTDIR}/_ext/1358597875/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/interrupt_manager.o: ../CommonFiles/source/interrupt_manager.c  .generated_files/flags/standalone/2a563cca1518b5e0b46b9f35dc8f59f93b20bf4 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1358597875/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c1.o: ../CommonFiles/source/i2c1.c  .generated_files/flags/standalone/5fd61f8e7cc89c2d2b0780182ef573f86cf4217 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c1.c  -o ${OBJECTDIR}/_ext/1358597875/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/d94d469d94fa715bf4e23f43ad27d21206729310 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/Events.o: ../CommonFiles/source/Events.c  .generated_files/flags/standalone/c82334111a59177f0e876796aa93b4e6bc7a0b86 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/Events.c  -o ${OBJECTDIR}/_ext/1358597875/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/Events.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/JetsonInterface.o: ../CommonFiles/source/JetsonInterface.c  .generated_files/flags/standalone/471c68ba7b094714a7efe36416e93d9a8ef568f7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/JetsonInterface.c  -o ${OBJECTDIR}/_ext/1358597875/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o: ../CommonFiles/source/pin_CustomISR.c  .generated_files/flags/standalone/686b4ea2f2b1b37be55a26f34b730462803bcd59 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pin_CustomISR.c  -o ${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o: ../CommonFiles/source/i2c_write_queue.c  .generated_files/flags/standalone/80d2408388ea95e77d00c7ab1d22e84d4bbdb249 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/i2c_write_queue.c  -o ${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/address_block_lookup.o: ../CommonFiles/source/address_block_lookup.c  .generated_files/flags/standalone/4c34b91ed67c8166cc3b6c5a77801bb7d07074c9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/address_block_lookup.c  -o ${OBJECTDIR}/_ext/1358597875/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/job_queue.o: ../CommonFiles/source/job_queue.c  .generated_files/flags/standalone/234c000babc973ca61efb73a17cf4f01e6a797f6 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/job_queue.c  -o ${OBJECTDIR}/_ext/1358597875/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/job_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/persist_store.o: ../CommonFiles/source/persist_store.c  .generated_files/flags/standalone/dd8892eabbc241fd9a5fb5972c6acf1e69dbc90f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/persist_store.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/persist_store.c  -o ${OBJECTDIR}/_ext/1358597875/persist_store.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/persist_store.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/pitchandroll.o: ../CommonFiles/source/pitchandroll.c  .generated_files/flags/standalone/f14a02e0a17edc27375359ba636e913f62fa60a9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/pitchandroll.c  -o ${OBJECTDIR}/_ext/1358597875/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/pitchandroll.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/ArrayUtils.o: ../CommonFiles/source/ArrayUtils.c  .generated_files/flags/standalone/f579669a42d4d9e90d571e57fd40b21c8a5f3f15 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../CommonFiles/source/ArrayUtils.c  -o ${OBJECTDIR}/_ext/1358597875/ArrayUtils.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1358597875/ArrayUtils.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/fa84d234c75013b5ab0ff84a56dd4cee8d7d0ad9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/389e1c8e9288b8088c867a035eb5956eda0bc0c7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1358597875" 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/1358597875/flash.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../CommonFiles/source/flash.s  -o ${OBJECTDIR}/_ext/1358597875/flash.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/_ext/1358597875/flash.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/81cc2e4e3166eba1903b2cce23f587103476a447 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1358597875/flash.o: ../CommonFiles/source/flash.s  .generated_files/flags/standalone/4a814a09251f28d5e64de579c7233aa9d2582aaf .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
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
${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
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

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
