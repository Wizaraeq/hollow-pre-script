--ペンデュラムーン
function c101112030.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Add 1 "Pendulum" Pendulum monster from the Extra Deck to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112030,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101112030)
	e1:SetTarget(c101112030.thtg)
	e1:SetOperation(c101112030.thop)
	c:RegisterEffect(e1)
	--Add up to 2 Pendulum monsters from the Extra Deck to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112030,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112030+100)
	e2:SetTarget(c101112030.thtg2)
	e2:SetOperation(c101112030.thop2)
	c:RegisterEffect(e2)
	if not c101112030.global_check then
		c101112030.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c101112030.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101112030.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM) then
		Duel.RegisterFlagEffect(rp,101112030,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101112030.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101112030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112030.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c101112030.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c101112030.thfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c101112030.thfilter2(c,lsc,rsc)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsType(TYPE_PENDULUM) and c:GetLevel()>lsc and c:GetLevel()<rsc and c:IsAbleToHand()
end
function c101112030.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if chk==0 and not (lsc and rsc) then return false end
	lsc=lsc:GetLeftScale()
	rsc=rsc:GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.IsExistingMatchingCard(c101112030.thfilter2,tp,LOCATION_EXTRA,0,1,nil,lsc,rsc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c101112030.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Add cards to the hand
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not (lsc and rsc) then return end
	lsc=lsc:GetLeftScale()
	rsc=rsc:GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c101112030.thfilter2,tp,LOCATION_EXTRA,0,1,2,nil,lsc,rsc)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ResetFlagEffect(tp,101112030)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c101112030.discon)
	e1:SetValue(c101112030.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetCondition(c101112030.discon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c101112030.discon)
	e3:SetOperation(c101112030.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101112030.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c101112030.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,101112030)==0
end
function c101112030.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and p==tp and bit.band(loc,LOCATION_PZONE)~=0 then
		Duel.NegateEffect(ev)
	end
end