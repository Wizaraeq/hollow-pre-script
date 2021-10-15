--ガーディアン・キマイラ
function c101107040.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101107040.ffilter,3,false)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(c101107040.matlimit)
	c:RegisterEffect(e0)
	--Draw and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101107040)
	e1:SetCondition(c101107040.condition)
	e1:SetTarget(c101107040.target)
	e1:SetOperation(c101107040.operation)
	c:RegisterEffect(e1)
	--Cannot be targeted by opponent's effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101107040.immcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c101107040.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()) and mg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
end
function c101107040.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c101107040.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and re and re:IsActiveType(TYPE_SPELL)
end
function c101107040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local hc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local fc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return hc>0 and fc>0 and Duel.IsPlayerCanDraw(tp,hc) and #dg>=fc end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,hc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,#dg,fc,1-tp,LOCATION_ONFIELD)
end
function c101107040.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	local hc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local fc=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,hc,REASON_EFFECT)==hc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,fc,fc,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c101107040.immcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,24094653)
end
