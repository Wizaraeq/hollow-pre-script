--神碑の泉
function c100418027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate "Mysterune" Quick-Play Spells from your hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x27e))
	c:RegisterEffect(e2)
	--Recycle and Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100418027,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100418027.drcon)
	e3:SetTarget(c100418027.drtg)
	e3:SetOperation(c100418027.drop)
	c:RegisterEffect(e3)
end
function c100418027.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsSetCard(0x27e) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		and re:IsActiveType(TYPE_QUICKPLAY)
end
function c100418027.tdfilter(c)
	return c:IsSetCard(0x27e) and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsAbleToDeck()
end
function c100418027.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100418027.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100418027.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local ct=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100418027.tdfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function c100418027.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end