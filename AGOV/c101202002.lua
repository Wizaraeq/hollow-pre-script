--覇王眷竜ライトヴルム
function c101202002.initial_effect(c)
	aux.AddCodeList(c,13331639)
	aux.EnablePendulumAttribute(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101202002)
	e1:SetTarget(c101202002.sptg)
	e1:SetOperation(c101202002.spop)
	c:RegisterEffect(e1)
	--Add 1 "Supreme King Dragon" or "Supreme King Gate" Pendulum Monster to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202002,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101202002+100)
	e2:SetTarget(c101202002.thtg)
	e2:SetOperation(c101202002.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Add this card to the hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101202002,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,101202002+200)
	e4:SetCondition(c101202002.ethcon)
	e4:SetTarget(c101202002.ethtg)
	e4:SetOperation(c101202002.ethop)
	c:RegisterEffect(e4)
end
function c101202002.zcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101202002.zarcfilter(c,tp)
	return c:IsFaceup() and c:IsCode(13331639)
		and Duel.IsExistingMatchingCard(c101202002.zcfilter,tp,LOCATION_MZONE,0,1,c)
end
function c101202002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101202002.zarcfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101202002.pendfilter(c,att,lv)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not (c:GetAttribute()==att and c:IsLevel(lv))
end
function c101202002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c101202002.pendfilter,tp,LOCATION_MZONE,0,c,c:GetAttribute(),c:GetLevel())
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(101202002,3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	sg:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101202002,4))
	local sc=sg:Select(tp,1,1,nil)
	if sc then
		Duel.HintSelection(sc)
		Duel.BreakEffect()
		local tc=(sg-sc):GetFirst()
		--Copy attribute and level
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(sc:GetFirst():GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(sc:GetFirst():GetLevel())
		tc:RegisterEffect(e2)
	end
end
function c101202002.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f8,0x20f8) and c:IsAbleToHand()
end
function c101202002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202002.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c101202002.exfilter(c)
	return c:IsSetCard(0x20f8) and (c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil))
end
function c101202002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101202002.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	local sg=Duel.GetMatchingGroup(c101202002.exfilter,tp,LOCATION_EXTRA,0,nil)
	if #sg==0 or not Duel.SelectYesNo(tp,aux.Stringid(101202002,5)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	Duel.BreakEffect()
	if sc:IsType(TYPE_SYNCHRO) then
		Duel.SynchroSummon(tp,sc,nil,mg)
	elseif sc:IsType(TYPE_XYZ) then
		Duel.XyzSummon(tp,sc,nil)
	end
end
function c101202002.ethfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousTypeOnField()&TYPE_PENDULUM==TYPE_PENDULUM
end
function c101202002.ethcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c101202002.ethfilter,1,nil,tp) 
end
function c101202002.ethtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,0)
end
function c101202002.ethop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
