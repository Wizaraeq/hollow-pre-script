--白の枢機竜
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,68468459,s.ffilter,6,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--This card can attack all monsters your opponent controls, once each
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Cannot declare an attack unless you send 1 card from your Extra Deck to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(s.atcost)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	--Send all cards in both players' Extra Decks to the GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
function s.ffilter(c,fc,sub,mg,sg)
	local tp=fc:GetControler()
	if not (c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)) then return false end
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_EXTRA,0,1,nil)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.tgconfilter(c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return false end
	local g=Duel.GetMatchingGroup(s.tgconfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=6
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end