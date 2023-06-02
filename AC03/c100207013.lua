--Ｎｏ.１ インフェクション・バアル・ゼブル
function c100207013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	c:EnableReviveLimit()
	--Look at your opponent's Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207013,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100207013)
	e1:SetCondition(c100207013.tgcon)
	e1:SetTarget(c100207013.tgtg)
	e1:SetOperation(c100207013.tgop)
	c:RegisterEffect(e1)
	--Destroy 1 card your opponent controls
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207013,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100207013+100)
	e2:SetCost(c100207013.descost)
	e2:SetTarget(c100207013.destg)
	e2:SetOperation(c100207013.desop)
	c:RegisterEffect(e2)
	--Attach 1 card from your opponent's GY to this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100207013,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100207013.matcon)
	e3:SetTarget(c100207013.mattg)
	e3:SetOperation(c100207013.matop)
	c:RegisterEffect(e3)
end
aux.xyz_number[100207013]=1
function c100207013.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c100207013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c100207013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.ShuffleExtra(1-tp)
end
function c100207013.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100207013.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100207013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local dam=math.ceil(tc:GetAttack()/2)
		if not tc:IsType(TYPE_MONSTER) and dam<0 or tc:IsFacedown() then dam=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c100207013.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100207013.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,1-tp,0)
end
function c100207013.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Overlay(c,g)
	end
end
