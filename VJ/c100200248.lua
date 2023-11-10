--閃術兵器－Ｓ.Ｐ.Ｅ.Ｃ.Ｔ.Ｒ.Ａ.
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,s.lcheck)
	c:EnableReviveLimit()
-- Must first be Link Summoned
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.lnklimit)
	c:RegisterEffect(e0)
	--Negate the effect of opponent's activated effect and destroy 1 card your opponent controls
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--Loses 3000 ATK while you have no Spells in your GY
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(-3000)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain(true)>=2
		and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g,true)
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.atkcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_SPELL)
end