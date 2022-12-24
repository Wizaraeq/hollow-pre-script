--液状巨人ダイダラタント
function c100298003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Attach this card to an Xyz monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100298003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100298003)
	e1:SetTarget(c100298003.ovtg)
	e1:SetOperation(c100298003.ovop)
	c:RegisterEffect(e1)
	--Place this card from the Monster Zone in the Pendulum Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100298003,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100298003+100)
	e2:SetCost(c100298003.plcost)
	e2:SetTarget(c100298003.pltg)
	e2:SetOperation(c100298003.plop)
	c:RegisterEffect(e2)
	--Place this card in the Pendulum Zone if destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100298003,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,100298003+200)
	e3:SetCondition(c100298003.pencon)
	e3:SetTarget(c100298003.pentg)
	e3:SetOperation(c100298003.penop)
	c:RegisterEffect(e3)
end
c100298003.pendulum_level=4
function c100298003.ovfilter(c,mc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c100298003.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100298003.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100298003.ovfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100298003.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100298003.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c100298003.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100298003.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and e:GetHandler():IsType(TYPE_PENDULUM) end
end
function c100298003.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c100298003.plop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100298003.tefilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100298003,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100298003.tefilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		end
	end
end
function c100298003.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE|REASON_EFFECT)
end
function c100298003.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c100298003.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end