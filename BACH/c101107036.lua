--超魔導戦士－マスター・オブ・カオス
function c101107036.initial_effect(c)
	--fusion material
	aux.AddFusionProcCodeFun(c,46986414,c101107036.mfilter,1,true,true)
	c:EnableReviveLimit()
	-- Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101107036)
	e1:SetCondition(c101107036.spcon)
	e1:SetTarget(c101107036.sptg)
	e1:SetOperation(c101107036.spop)
	c:RegisterEffect(e1)
	-- Banish all opponent monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107036,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101107036+100)
	e2:SetCost(c101107036.rmcost)
	e2:SetTarget(c101107036.rmtg)
	e2:SetOperation(c101107036.rmop)
	c:RegisterEffect(e2)
	-- Add Spell to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107036,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,101107036+200)
	e3:SetCondition(c101107036.thcon)
	e3:SetTarget(c101107036.thtg)
	e3:SetOperation(c101107036.thop)
	c:RegisterEffect(e3)
end
function c101107036.mfilter(c)
	return c:IsFusionType(TYPE_RITUAL) and c:IsFusionSetCard(0xcf)
end
function c101107036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101107036.spfilter(c,e,tp)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107036.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101107036.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101107036.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101107036.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101107036.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107036.rfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and (c:IsControler(tp) or c:IsFaceup())
end
function c101107036.attcheck(sg)
	return sg:GetClassCount(Card.GetAttribute)==2
end
function c101107036.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c101107036.rfilter,nil,tp)
	if chk==0 then return rg:CheckSubGroup(c101107036.attcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,c101107036.attcheck,false,2,2,tp)
	aux.UseExtraReleaseCount(g,tp)
	Duel.Release(g,REASON_COST)
end
function c101107036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,LOCATION_MZONE,1-tp)
end
function c101107036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Remove(g,0,REASON_EFFECT)
	end
end
function c101107036.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c101107036.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101107036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101107036.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101107036.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101107036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101107036.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end