--ヴェーダ＝ウパニシャッド
function c101202005.initial_effect(c)
	c:SetSPSummonOnce(101202005)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x166,LOCATION_PZONE)
	--Special Summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--place counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202005,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c101202005.ctcon)
	e1:SetCost(c101202005.ctcost)
	e1:SetTarget(c101202005.cttg)
	e1:SetOperation(c101202005.ctop)
	c:RegisterEffect(e1)
	--increase scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(c101202005.slval)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2b)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c101202005.pspcost)
	e3:SetTarget(c101202005.psptg)
	e3:SetOperation(c101202005.pspop)
	c:RegisterEffect(e3)
	--skip to end phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101202005,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101202005.epcon)
	e4:SetCost(c101202005.epcost)
	e4:SetOperation(c101202005.epop)
	c:RegisterEffect(e4)
	--to hand and summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101202005,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c101202005.thcon)
	e5:SetTarget(c101202005.thtg)
	e5:SetOperation(c101202005.thop)
	c:RegisterEffect(e5)
end
function c101202005.ctcfilter(c,tp)
	return c:GetPreviousTypeOnField()&TYPE_MONSTER~=0
end
function c101202005.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(c101202005.ctcfilter,1,nil)
end
function c101202005.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(101202005)==0 end
	c:RegisterFlagEffect(101202005,RESET_CHAIN,0,1)
end
function c101202005.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x166,3) end
end
function c101202005.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	c:AddCounter(0x166,3)
end
function c101202005.slval(e)
	return e:GetHandler():GetCounter(0x166)
end
function c101202005.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x166,12,REASON_COST) end
	c:RemoveCounter(tp,0x166,12,REASON_COST)
end
function c101202005.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101202005.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function c101202005.epcfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c101202005.epcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101202005.epcfilter,1,nil,1-tp) and rp==1-tp
end
function c101202005.epcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,POS_FACEDOWN)>=12 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,12,12,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101202005.epop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101202005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101202005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101202005.spfilter(c,e,tp)
	return c:IsSetCard(0x29a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c101202005.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c101202005.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101202005,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end