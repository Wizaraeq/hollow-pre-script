--電脳堺虎－虎々
function c101112046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--Negate the effects of 2 monsters on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112046,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetCost(c101112046.discost)
	e1:SetTarget(c101112046.distg)
	e1:SetOperation(c101112046.disop)
	c:RegisterEffect(e1)
	--Can attack directly
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c101112046.efcon2)
	c:RegisterEffect(e2)
	--Unaffected by activated effects, except "Virtual World" cards
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101112046.efcon4)
	e3:SetValue(c101112046.efilter)
	c:RegisterEffect(e3)
end
function c101112046.etfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x114e)
end
function c101112046.efcon2(e)
	return Duel.IsExistingMatchingCard(c101112046.etfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c101112046.efcon4(e)
	return Duel.GetMatchingGroupCount(c101112046.etfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)==4
end
function c101112046.efilter(e,te)
	return te:IsActivated() and not te:GetOwner():IsSetCard(0x14e)
end
function c101112046.tgfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and c:IsCanBeEffectTarget(e)
end
function c101112046.rescon(sg,e,tp)
	return sg:IsExists(Card.IsControler,1,nil,tp) and sg:IsExists(c101112046.propfilter,1,nil,sg:GetFirst())
end
function c101112046.propfilter(c,sc)
	return sc and not c:IsRace(sc:GetRace()) and not c:IsAttribute(sc:GetAttribute())
end
function c101112046.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101112046.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c101112046.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return g:CheckSubGroup(c101112046.rescon,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tg=g:SelectSubGroup(tp,c101112046.rescon,false,2,2,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,2,0,0)
end
function c101112046.disop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	if #dg==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(dg) do
		if tc:IsFaceup() and not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
	end
end
