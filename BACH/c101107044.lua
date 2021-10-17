--ＤＤＤ赦俿王デス・マキナ
function c101107044.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	c:SetUniqueOnField(1,0,101107044,LOCATION_MZONE)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,2,c101107044.ovfilter,aux.Stringid(101107044,0))
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107044,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101107044)
	e1:SetTarget(c101107044.sptg)
	e1:SetOperation(c101107044.spop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107044,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101107044.discon)
	e2:SetTarget(c101107044.distg)
	e2:SetOperation(c101107044.disop)
	c:RegisterEffect(e2)
	--pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107044,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101107044.pencon)
	e3:SetTarget(c101107044.pentg)
	e3:SetOperation(c101107044.penop)
	c:RegisterEffect(e3)
end
function c101107044.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function c101107044.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsForbidden()
end
function c101107044.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101107044.penfilter(chkc) end
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	local pc=(pg-c):GetFirst()
	if chk==0 then return pc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and pc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101107044.penfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local g=Duel.SelectTarget(tp,c101107044.penfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,pc,1,tp,0)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
	end
end
function c101107044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	local pc=(pg-c):GetFirst()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and pc and Duel.SpecialSummon(pc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c101107044.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return not e:GetHandler():IsStatus(STATUS_CHAINING+STATUS_BATTLE_DESTROYED) and rp==1-tp
		and (rc:GetOriginalType()&TYPE_MONSTER)~=0 and rc:IsOnField() and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101107044.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xae)
end
function c101107044.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>=2
		or Duel.IsExistingMatchingCard(c101107044.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c101107044.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e) and c:GetOverlayCount()>=2
	local b2=Duel.IsExistingMatchingCard(c101107044.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if not (b1 or b2) then return end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101107044,4),aux.Stringid(101107044,5))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101107044,4))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101107044,5))+1
	end
	local success=false
	if op==0 then
		success=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c101107044.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		success=#dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0
	end
	local rc=re:GetHandler()
	if success and rc:IsRelateToEffect(re) and c:IsRelateToEffect(e) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rc)
	end
end
function c101107044.pencon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c101107044.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101107044.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
