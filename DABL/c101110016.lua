--蟲の忍者－蜜
function c101110016.initial_effect(c)
	--Special Summon itself from your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110016)
	e1:SetCondition(c101110016.spcon)
	e1:SetTarget(c101110016.sptg)
	e1:SetOperation(c101110016.spop)
	c:RegisterEffect(e1)
	--Change positions and negate activated effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110016,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110016+100)
	e2:SetCondition(c101110016.negcon)
	e2:SetTarget(c101110016.negtg)
	e2:SetOperation(c101110016.negop)
	c:RegisterEffect(e2)
end
function c101110016.cfilter(c)
	return (c:IsFaceup() and c:IsSetCard(0x2b)) or (c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsLocation(LOCATION_MZONE))
end
function c101110016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101110016.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101110016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c101110016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101110016.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c101110016.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsPosition(POS_FACEDOWN_DEFENSE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE) and c:IsCanTurnSet() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEDOWN_DEFENSE):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_POSITION,Group.FromCards(c,tc),1,tp,0)
	if tc:IsSetCard(0x2b) and not tc:IsCode(id) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end
function c101110016.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0
		and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)>0
		and tc:IsSetCard(0x2b) and not tc:IsCode(101110016) then
		Duel.BreakEffect()
		Duel.NegateEffect(ev)
	end
end