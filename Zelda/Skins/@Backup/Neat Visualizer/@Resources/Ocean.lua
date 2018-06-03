-- Ocean v2.0
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

function Initialize()
  measure, measureBuffer, meter = {}, {}, {}
  measure2, measureBuffer2, meter2 = {}, {}, {}
  interpolateSpan = SELF:GetNumberOption("InterpolateSpan")
  mu = 1 / interpolateSpan
  mu2 = 1 / interpolateSpan
  spectrumSize = SELF:GetNumberOption("SpectrumSize")

  meterIter, lowerLimit, upperLimit = 1, SELF:GetNumberOption("LowerLimit") + 1, SELF:GetNumberOption("UpperLimit") + 1
  meterIter2 = 1
  for i = lowerLimit, upperLimit do
    meter[i], measure[i] = {}, SKIN:GetMeasure(SELF:GetOption("MeasureBaseName") .. i-1)
    meter2[i], measure2[i] = {}, SKIN:GetMeasure(SELF:GetOption("MeasureBaseName") .. i+16-1)
    for j = 1, interpolateSpan do
      meterIter, meter[i][j] = meterIter + 1, SKIN:GetMeter(SELF:GetOption("MeterBaseName") .. meterIter)
      meterIter2, meter2[i][j] = meterIter2 + 1, SKIN:GetMeter(SELF:GetOption("MeterBaseName") .. meterIter2+16)
    end
  end
end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CubicInterpolate(y0,y1,y2,y3,mu)
   local mu2,a0 = mu*mu, y3-y2-y0+y1
   local a1 = y0-y1-a0
   return (a0*mu*mu2+a1*mu2+(y2-y0)*mu+y1)
end
  
function Update()
  for i = lowerLimit, upperLimit do 
    measureBuffer[i] = measure[i]:GetValue()
    measureBuffer2[i] = measure2[i]:GetValue() 
  end

  local spectrumSize = spectrumSize
  for i = lowerLimit, upperLimit-1 do
    local localMu, meter = 0, meter[i]
    local localMu2, meter2 = 0, meter2[i]
    local y0, y3 = measureBuffer[i-1 < lowerLimit and lowerLimit or i-1], measureBuffer[i+2 > upperLimit and upperLimit or i+2]
    local y02, y32 = measureBuffer2[i-1 < lowerLimit and lowerLimit or i-1], measureBuffer2[i+2 > upperLimit and upperLimit or i+2]
    local y1, y2 = measureBuffer[i], measureBuffer[i+1]
    local y12, y22 = measureBuffer2[i], measureBuffer2[i+1]
    for j = 1, interpolateSpan do
      localMu = localMu + mu
      localMu2 = localMu2 + mu2
      SKIN:Bang("!CommandMeasure", "ScriptCallback1", "x=" .. CubicInterpolate(y0,y1,y2,y3,localMu))
      SKIN:Bang("!CommandMeasure", "ScriptCallback2", "x=" .. CubicInterpolate(y02,y12,y22,y32,localMu2))
      SKIN:Bang("!UpdateMeterGroup", "Meter")
      SKIN:Bang("!UpdateMeasure", "ScriptCallback1")
      SKIN:Bang("!UpdateMeasure", "ScriptCallback2")
      spectrumSize = spectrumSize - 1
      if spectrumSize == 0 then
        return
      end
    end
  end
end