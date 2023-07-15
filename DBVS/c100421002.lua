--メメント・ホーン・ドラゴン
function c100421002.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100421002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100421002.spcon)
	c:RegisterEffect(e1)
	-- Destroy 3 face-up cards on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421002,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100421002+100)
	e2:SetCondition(c100421002.descon)
	e2:SetTarget(c100421002.destg)
	e2:SetOperation(c100421002.desop)
	c:RegisterEffect(e2)
end
function c100421002.spfilter(c)
	return c:IsSetCard(0x2a1) and c:IsType(TYPE_MONSTER)
end
function c100421002.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c100421002.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c100421002.mementofilter(c,tp)
	return c:IsSetCard(0x2a1) and c:IsControler(tp)
end
function c100421002.desfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c100421002.rescon(sg,e,tp)
	return sg:IsExists(c100421002.mementofilter,1,nil,tp)
end
function c100421002.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100421002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c100421002.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return g:CheckSubGroup(c100421002.rescon,3,3,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,c100421002.rescon,false,3,3,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,tp,0)
end
function c100421002.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=sg:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
