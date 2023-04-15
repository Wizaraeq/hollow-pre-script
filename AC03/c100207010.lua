--トライアングル－Ｏ
function c100207010.initial_effect(c)
	--Destroy all cards on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207010,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100207010) 
	e1:SetCondition(c100207010.descon)
	e1:SetTarget(c100207010.destg)
	e1:SetOperation(c100207010.desop)
	c:RegisterEffect(e1)
	--Shuffle 1 "Crystal Skull", 1 "Ashoka Pillar", and 1 "Cabrera Stone" into the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207010,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100207010) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100207010.tdtg)
	e2:SetOperation(c100207010.tdop)
	c:RegisterEffect(e2)
end
function c100207010.dcfilter1(c)
	return c:IsFaceup() and c:IsCode(7903368)
end
function c100207010.dcfilter2(c)
	return c:IsFaceup() and c:IsCode(100207008)
end
function c100207010.dcfilter3(c)
	return c:IsFaceup() and c:IsCode(100207009)
end
function c100207010.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100207010.dcfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c100207010.dcfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c100207010.dcfilter3,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100207010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #sg>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c100207010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	--Reflect effect damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c100207010.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100207010.val(e,re,ev,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
function c100207010.tdfilter(c,e)
	return c:IsCode(7903368,100207008,100207009) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c100207010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c100207010.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return sg:CheckSubGroup(aux.dncheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=sg:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c100207010.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end