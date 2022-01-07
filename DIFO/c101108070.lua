--セリオンズ・クロス
function c101108070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101108070,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108070.condition)
	e1:SetTarget(c101108070.target)
	e1:SetOperation(c101108070.activate)
	c:RegisterEffect(e1)
end
function c101108070.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27a)
end
function c101108070.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c101108070.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local b1=Duel.IsChainDisablable(ev) and not rc:IsDisabled()
	local b2=rc:IsAbleToRemove() and rc:IsRelateToEffect(re) and not rc:IsLocation(LOCATION_REMOVED)
	local b3=b1 and b2 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,101108054)
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(101108070,0),aux.Stringid(101108070,1),aux.Stringid(101108070,2))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101108070,0),aux.Stringid(101108070,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101108070,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101108070,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	elseif op==1 then
		Duel.SetTargetCard(rc)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,1-tp,rc:GetLocation())
	elseif op==2 then
		Duel.SetTargetCard(rc)
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,1-tp,rc:GetLocation())
	end
end
function c101108070.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local rc=re:GetHandler()
	--Negate that effect
	if op==0 then
		Duel.NegateEffect(ev)
	--Banish that monster
	elseif op==1 then
		if rc:IsRelateToEffect(e) then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	--Activate both, in sequence
	elseif op==2 then
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
