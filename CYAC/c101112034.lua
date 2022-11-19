--サイバース・ディセーブルム
function c101112034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101112034.matfilter,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),true)
	--Special Summon 1 Cyberse monster from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101112034)
	e1:SetTarget(c101112034.sptg)
	e1:SetOperation(c101112034.spop)
	c:RegisterEffect(e1)
	--Negate the activation of an opponent's Spell/Trap or effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112034,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,101112034+100)
	e2:SetCondition(c101112034.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101112034.negtg)
	e2:SetOperation(c101112034.negop)
	c:RegisterEffect(e2)
end
function c101112034.matfilter(c,fc,sumtype,tp)
	return c:IsFusionType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsRace(RACE_CYBERSE)
end
function c101112034.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112034.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101112034.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101112034.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and c:IsFaceup() and c:IsLevelAbove(1)
		and not c:IsLevel(tc:GetLevel()) and Duel.SelectYesNo(tp,aux.Stringid(101112034,2)) then
		Duel.BreakEffect()
		--Change this card's Level
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c101112034.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLinkAbove(4)
end
function c101112034.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c101112034.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101112034.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101112034.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
