--音響戦士ロックス
function c101108042.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add 1 pendulum from extra to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108042,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101108042+100)
	e1:SetTarget(c101108042.thtg)
	e1:SetOperation(c101108042.thop)
	c:RegisterEffect(e1)
	--destroy 1 attacking monster and this card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101108042.atkcon)
	e2:SetTarget(c101108042.atktg)
	e2:SetOperation(c101108042.atkop)
	c:RegisterEffect(e2)
	-- place itself in Pzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108042,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c101108042.pencon)
	e3:SetTarget(c101108042.pentg)
	e3:SetOperation(c101108042.penop)
	c:RegisterEffect(e3)
	-- special summone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101108042,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101108042+200)
	e4:SetTarget(c101108042.thtg)
	e4:SetOperation(c101108042.thop)
	c:RegisterEffect(e4)
	-- Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(101108042,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101108042+300)
	e5:SetCondition(c101108042.descon)
	e5:SetTarget(c101108042.destg)
	e5:SetOperation(c101108042.desop)
	c:RegisterEffect(e5)
end
function c101108042.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101108042.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108042.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c101108042.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108042.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101108042.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker() and Duel.GetAttacker():GetControler()~=tp
end
function c101108042.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Group.CreateGroup()
	if chk==0 then return true end
	g:AddCard(Duel.GetAttacker())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101108042.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c:IsRelateToEffect(e) and tc:IsRelateToBattle() then
		local g=Group.FromCards(c,tc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101108042.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c101108042.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101108042.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c101108042.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(75304793,tp,LOCATION_FZONE)
end
function c101108042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c101108042.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if #g>0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
