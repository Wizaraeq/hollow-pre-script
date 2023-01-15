--液状巨人ダイダラタント
--Script by 奥克斯
function c100298003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyz material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100298003,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100298003)
	e1:SetTarget(c100298003.xyztg)
	e1:SetOperation(c100298003.xyzop)
	c:RegisterEffect(e1)
	--pzone move 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100298003,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100298003+100)
	e2:SetCost(c100298003.pencost1)
	e2:SetTarget(c100298003.pentg)
	e2:SetOperation(c100298003.penop1)
	c:RegisterEffect(e2)
	--pzone move 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100298003,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100298003+200)
	e3:SetCondition(c100298003.pencon2)
	e3:SetTarget(c100298003.pentg)
	e3:SetOperation(c100298003.penop2)
	c:RegisterEffect(e3)
end
c100298003.pendulum_level=4
function c100298003.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c100298003.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100298003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100298003.filter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100298003.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100298003.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsImmuneToEffect(e) and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c100298003.pencost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100298003.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c100298003.pmfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c100298003.penop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100298003.pmfilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100298003,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100298003.pmfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c100298003.pencon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100298003.penop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
