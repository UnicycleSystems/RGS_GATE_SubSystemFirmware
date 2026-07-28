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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/mcc.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c RGS_MCC_Copies/uart1.c main.c bq40z50.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/RGS_MCC_Copies/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/bq40z50.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/system.o.d ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d ${OBJECTDIR}/RGS_MCC_Copies/uart1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/bq40z50.o.d ${OBJECTDIR}/Events.o.d ${OBJECTDIR}/JetsonInterface.o.d ${OBJECTDIR}/pin_CustomISR.o.d ${OBJECTDIR}/i2c_write_queue.o.d ${OBJECTDIR}/address_block_lookup.o.d ${OBJECTDIR}/job_queue.o.d ${OBJECTDIR}/pitchandroll.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/RGS_MCC_Copies/uart1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/bq40z50.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o

# Source Files
SOURCEFILES=mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/mcc.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c RGS_MCC_Copies/uart1.c main.c bq40z50.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c



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
	${MAKE}  -f nbproject/Makefile-standalone.mk ${DISTDIR}/RGS_BringUp.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/standalone/aaaea79b80cad1dc2a26cceccf7bf6168bc1fb52 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/standalone/76b2118516ee5d500f8b6a6a9219f2a88e41c3d2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/mcc.o: RGS_MCC_Copies/mcc.c  .generated_files/flags/standalone/1d84e61f49c7c537f17877c053719be7e7a7977d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/mcc.c  -o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/standalone/a26eae6fdb1b0e363902570298227abc6b996109 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/standalone/2a3745ba4977e3b33cfe3c70a679220b90102df5 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/standalone/ee13505b5d18a7c95ab8f5b1d714db1e113a7395 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/standalone/6a90124e0a3e25b0d2e04fdb0dfcbbfa49f58532 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/standalone/9551baa3082c4aface35dc667f4a84125564e9d2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/standalone/e7c732792dd868fe1487bc43b3f4ce279e61ea5 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/standalone/8f99f3b858dc5a84595891c2512d090ea5c40f5a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/standalone/889fd2309d051e292452ffc9b8a69f7ac010b2f9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/uart1.o: RGS_MCC_Copies/uart1.c  .generated_files/flags/standalone/7a96b2d6b8172cbc4b45728e89f3b149f9f1b2e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/uart1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/uart1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/uart1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/b3639385b8617e1441143387505a7aa52b5f4a8c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/bq40z50.o: bq40z50.c  .generated_files/flags/standalone/8edc479b48488209912b48f6d8ed9c943067482d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  bq40z50.c  -o ${OBJECTDIR}/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/bq40z50.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/standalone/bf005c6df412df75c0be1602eb51ed73af6a8f1f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/standalone/4c07d882e99cd46e76506cb750c27bb7bf65cf5f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/standalone/1949fb4f6374098c24804972dade64c173461693 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/standalone/51bb3e0a9a793eb3554eec1f1278669f84335112 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/standalone/bd13506924df2976113a25d1b19d2c4a0dbbef75 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/standalone/815ab2699ed7b4163011d550e66e14f177041cf0 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/standalone/6e3b765c7ede1de02bb47abe16602fe23428fd72 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/standalone/4f779dbc55a4adb51c478e6697684586086bf845 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/standalone/6fe7eba54054be2a2d3063e331433d98792837a1 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/mcc.o: RGS_MCC_Copies/mcc.c  .generated_files/flags/standalone/39520d8f3f44c692e003046cde46de15c2f1cb86 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/mcc.c  -o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/standalone/69112394d29895977dc0b69e77896ebcb24eeb80 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/standalone/dc768146358c4d7a06317bb41b74cedeff7ddb38 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/standalone/87446e4e8ba9d7c425e804dc1781c063d94bb708 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/standalone/c07eca532a9abc353b9fb53d46977e89d08def9f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/standalone/ea2759ef3c44598392f5b604fa68ccadc7b5b882 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/standalone/2563f29644649aefbd350ccde17b7b6b2d69149 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/standalone/1d7240ec81bf92b5e0b02626c86b533261624111 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/standalone/70cb9ecbac68cefd5acf3063824d432b14be60e9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/uart1.o: RGS_MCC_Copies/uart1.c  .generated_files/flags/standalone/3a85de397aef5367d90b3c0639a32de757a1da90 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/uart1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/uart1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/uart1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/371c157baba59632c3cf820a6f3e38cb63e49ce1 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/bq40z50.o: bq40z50.c  .generated_files/flags/standalone/52d1db2f6eb1e367ccbcc21ac25cd047a6fabbe0 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bq40z50.o.d 
	@${RM} ${OBJECTDIR}/bq40z50.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  bq40z50.c  -o ${OBJECTDIR}/bq40z50.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/bq40z50.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/standalone/794a632638e4a3170181324bca04dbc4d53f008d .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/standalone/152e1d7ad6a39038cdcd6a193e2eef41bcc9371 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/standalone/46b4400ea4d39904d0dafba00c207da96d61b780 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/standalone/c7175cf0448a42d2db5b59b061a46ba531647a4a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/standalone/655e6244c340cf7e1b64601d1472fe908c44d5e8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/standalone/a6478685a6dc7ad4161b92e623b75138c11558dd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/standalone/29df915125d6e2638801afeaf23542ba5b408916 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/eb9642e305b1b466fda586119e3dfc6b2df119ab .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/870e62e78f6349234894f0d16c83d463e528d829 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
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
