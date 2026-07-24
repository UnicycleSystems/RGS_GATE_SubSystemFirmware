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
SOURCEFILES_QUOTED_IF_SPACED=mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/mcc.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c main.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o
POSSIBLE_DEPFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o.d ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/system.o.d ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/Events.o.d ${OBJECTDIR}/JetsonInterface.o.d ${OBJECTDIR}/pin_CustomISR.o.d ${OBJECTDIR}/i2c_write_queue.o.d ${OBJECTDIR}/address_block_lookup.o.d ${OBJECTDIR}/job_queue.o.d ${OBJECTDIR}/pitchandroll.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/mcc_generated_files/where_was_i.o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o ${OBJECTDIR}/RGS_MCC_Copies/system.o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o ${OBJECTDIR}/RGS_MCC_Copies/clock.o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o ${OBJECTDIR}/main.o ${OBJECTDIR}/Events.o ${OBJECTDIR}/JetsonInterface.o ${OBJECTDIR}/pin_CustomISR.o ${OBJECTDIR}/i2c_write_queue.o ${OBJECTDIR}/address_block_lookup.o ${OBJECTDIR}/job_queue.o ${OBJECTDIR}/pitchandroll.o

# Source Files
SOURCEFILES=mcc_generated_files/where_was_i.s RGS_MCC_Copies/pin_manager.c RGS_MCC_Copies/system.c RGS_MCC_Copies/mcc.c RGS_MCC_Copies/FrontAlignLaser.c RGS_MCC_Copies/clock.c RGS_MCC_Copies/tmr1.c RGS_MCC_Copies/tmr2.c RGS_MCC_Copies/tmr4.c RGS_MCC_Copies/i2c2.c RGS_MCC_Copies/interrupt_manager.c RGS_MCC_Copies/i2c1.c main.c Events.c JetsonInterface.c pin_CustomISR.c i2c_write_queue.c address_block_lookup.c job_queue.c pitchandroll.c



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
	${MAKE}  -f nbproject/Makefile-standalone.mk ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=24FJ64GA004
MP_LINKER_FILE_OPTION=,--script=p24FJ64GA004.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/standalone/baf72650656181aade653d39b02c18d0b5dd00fd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/standalone/6562e08f6484990ccc799cbfb047fbcda2b7215b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/mcc.o: RGS_MCC_Copies/mcc.c  .generated_files/flags/standalone/53c7691ae81623bd5a996aa91fdcca79547f5ff7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/mcc.c  -o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/standalone/e46b5605dfc65cc25b701a52eb911547bb20d153 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/standalone/e6e52376b2fddea3d9bab63af34b7b9d9375e5c3 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/standalone/c591f03ba9aa8a319301695e78c585acc515ca54 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/standalone/493e26d6e4aae141d419cc3bd1677246683f8f6b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/standalone/f77b86c1b2a3b49b7f54b5c281c856edfb1b83 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/standalone/b36086aa3d155907b63961a9a8fdfd0eb1baafc5 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/standalone/7c959fdb7f528adad3d34ee459501720ed1942b .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/standalone/69c9c0650089c45d422159ffdc57c7dd3c82c2fd .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/b730467b76b9742f041f750d05c3d4f47339941f .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/standalone/28293460ecd523096e8ffddc7b6ee96fca4e003e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/standalone/5e0f4b870b0b075621e8879acd00a3314e656073 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/standalone/cc41a6c76753165fcedfe653f9bdc62e22a92b13 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/standalone/a6f277fd342f184db50b5cb945b3cb5c4202420e .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/standalone/85868f9c69460c5b45f5131ba1815a6f1b844dd7 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/standalone/bbcb4ee6a7616095fab3a59e774944ac92cf3e73 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/standalone/2fd875a870f7b7ef1cc79c8d32c23730201bb4d9 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1    -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o: RGS_MCC_Copies/pin_manager.c  .generated_files/flags/standalone/e19abf964bee4f600178592a92b355af914b60f0 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/pin_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/pin_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/system.o: RGS_MCC_Copies/system.c  .generated_files/flags/standalone/194bc9dd858faa03ad787906a2a59483db4dc7cb .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/system.c  -o ${OBJECTDIR}/RGS_MCC_Copies/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/system.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/mcc.o: RGS_MCC_Copies/mcc.c  .generated_files/flags/standalone/515bec7b3f5280bf0069ef2bc63d7bcaf02282f2 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/mcc.c  -o ${OBJECTDIR}/RGS_MCC_Copies/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/mcc.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o: RGS_MCC_Copies/FrontAlignLaser.c  .generated_files/flags/standalone/2f8041395a3a2476914607264b8e7b3f9ceaa283 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/FrontAlignLaser.c  -o ${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/FrontAlignLaser.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/clock.o: RGS_MCC_Copies/clock.c  .generated_files/flags/standalone/9500df8d867e04cf27825a731f7ae9dc0ae24cec .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/clock.c  -o ${OBJECTDIR}/RGS_MCC_Copies/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/clock.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr1.o: RGS_MCC_Copies/tmr1.c  .generated_files/flags/standalone/d50e789434756ea1b77c8ce9fa610a16ab5bfbb6 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr2.o: RGS_MCC_Copies/tmr2.c  .generated_files/flags/standalone/95686e97ece633d072b7e729063efea11f85486c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/tmr4.o: RGS_MCC_Copies/tmr4.c  .generated_files/flags/standalone/6392cbcb79361aa27af5145fcace7e26b5ffc4a3 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/tmr4.c  -o ${OBJECTDIR}/RGS_MCC_Copies/tmr4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/tmr4.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c2.o: RGS_MCC_Copies/i2c2.c  .generated_files/flags/standalone/86411e0a39f582cd8f33e99daf5ff950eb7f8e78 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c2.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c2.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o: RGS_MCC_Copies/interrupt_manager.c  .generated_files/flags/standalone/93600ba55103420f221a5f8207c62d341c181fa6 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/interrupt_manager.c  -o ${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/interrupt_manager.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGS_MCC_Copies/i2c1.o: RGS_MCC_Copies/i2c1.c  .generated_files/flags/standalone/52bf56bf1ba4a144885cd52974de28cabf164846 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/RGS_MCC_Copies" 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d 
	@${RM} ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGS_MCC_Copies/i2c1.c  -o ${OBJECTDIR}/RGS_MCC_Copies/i2c1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGS_MCC_Copies/i2c1.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/standalone/5ac76ce3002cf3e2f5ff1a570ec1a72430c15a32 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Events.o: Events.c  .generated_files/flags/standalone/eaed54a5264efabc5cee4be565d1587e330769e1 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Events.o.d 
	@${RM} ${OBJECTDIR}/Events.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Events.c  -o ${OBJECTDIR}/Events.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Events.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/JetsonInterface.o: JetsonInterface.c  .generated_files/flags/standalone/93b220d62cbc58937e1420d584ce9865da9f9538 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/JetsonInterface.o.d 
	@${RM} ${OBJECTDIR}/JetsonInterface.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  JetsonInterface.c  -o ${OBJECTDIR}/JetsonInterface.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/JetsonInterface.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pin_CustomISR.o: pin_CustomISR.c  .generated_files/flags/standalone/7b10b36e5dd00cd485b5b28c4e9100c3b788a84a .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o.d 
	@${RM} ${OBJECTDIR}/pin_CustomISR.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pin_CustomISR.c  -o ${OBJECTDIR}/pin_CustomISR.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pin_CustomISR.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/i2c_write_queue.o: i2c_write_queue.c  .generated_files/flags/standalone/7a91e977dd2892ba5e249082eede662b90dc1947 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o.d 
	@${RM} ${OBJECTDIR}/i2c_write_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  i2c_write_queue.c  -o ${OBJECTDIR}/i2c_write_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/i2c_write_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/address_block_lookup.o: address_block_lookup.c  .generated_files/flags/standalone/5c97bba80e90c8d7d3f33a5901745172fa2982e8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/address_block_lookup.o.d 
	@${RM} ${OBJECTDIR}/address_block_lookup.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  address_block_lookup.c  -o ${OBJECTDIR}/address_block_lookup.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/address_block_lookup.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/job_queue.o: job_queue.c  .generated_files/flags/standalone/21c72bd1eca59095bec894e2237e3c026f05bad8 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/job_queue.o.d 
	@${RM} ${OBJECTDIR}/job_queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  job_queue.c  -o ${OBJECTDIR}/job_queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/job_queue.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/pitchandroll.o: pitchandroll.c  .generated_files/flags/standalone/fbd10b1f825dbfab74ad906b19ad6608cdc43a6c .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pitchandroll.o.d 
	@${RM} ${OBJECTDIR}/pitchandroll.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  pitchandroll.c  -o ${OBJECTDIR}/pitchandroll.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/pitchandroll.o.d"        -g -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -DSTANDALONE_BUILD -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/4d71b8864d70a3e8af826898e3f5ec06ba467196 .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  mcc_generated_files/where_was_i.s  -o ${OBJECTDIR}/mcc_generated_files/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    -Wa,-MD,"${OBJECTDIR}/mcc_generated_files/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/mcc_generated_files/where_was_i.o: mcc_generated_files/where_was_i.s  .generated_files/flags/standalone/eb700f4bb08149d61174fd53bf8327860924fcfc .generated_files/flags/standalone/da39a3ee5e6b4b0d3255bfef95601890afd80709
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
${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x81F -mreserve=data@0x820:0x821 -mreserve=data@0x822:0x823 -mreserve=data@0x824:0x825 -mreserve=data@0x826:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/RGS_PuttingGate.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_standalone=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
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
