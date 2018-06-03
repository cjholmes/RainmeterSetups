[Rainmeter]
Update=16

[MeasureAudio]
Measure=Plugin
Plugin=AudioLevel
Port=#Port#
ID=#ID#
RMSAttack=0
RMSDecay=0
RMSGain=1
PeakAttack=0
PeakDecay=0
PeakGain=1
FFTSize=#FFTSize#
FFTOverlap=#FFTOverlap#
FFTAttack=#FFTAttack#
FFTDecay=#FFTDecay#
Bands=33
FreqMin=#FreqMin#
FreqMax=#FreqMax#
Sensitivity=#Sensitivity#
UpdateDivider=1

[DynamicSensitivity]
Measure=Calc
Formula=(#Sensitivity# - (MeasureAudio * 100 - #Sensitivity#))
IfCondition=((DynamicSensitivity > #Sensitivity#) && (#LoudnessEqualization# = 1))
IfTrueAction=[!SetOption MeasureAudio Sensitivity [DynamicSensitivity]]
IfConditionMode=1
UpdateDivider=1
; Average over the past 3 seconds to prevent stuttering
AverageSize=188

[DynamicFFTDecay]
Measure=Calc
Formula=(#FFTDecay# + (MeasureAudio * 100 - #Sensitivity#) * 10)
IfCondition=((DynamicSensitivity > #Sensitivity#) && (#LoudnessEqualization# = 1))
IfTrueAction=[!SetOption MeasureAudio FFTDecay [DynamicFFTDecay]]
IfConditionMode=1
UpdateDivider=1
AverageSize=188

@Include=#@#Bands.inc

[ScriptCallback1]
Measure=Script
ScriptFile=#@#Callback.lua

[ScriptCallback2]
Measure=Script
ScriptFile=#@#Callback.lua

[ScriptOcean]
Measure=Script
ScriptFile=#@#Ocean.lua
MeasureBaseName=MeasureAudio
LowerLimit=1
UpperLimit=16
InterpolateSpan=(Ceil(#Width# / 14))
SpectrumSize=#Width#
UpdateDivider=1



