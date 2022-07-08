--戎の忍者－冥禪
function c101110040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101110040.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--"Ninja" monsters can attack directly
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2b))
	c:RegisterEffect(e1)
	--Cannot be attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101110040.tgcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Special Summon 1 "Ninja" monster from the Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110040,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101110040)
	e3:SetCondition(c101110040.spcon)
	e3:SetTarget(c101110040.sptg)
	e3:SetOperation(c101110040.spop)
	c:RegisterEffect(e3)
end
function c101110040.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x2b) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c101110040.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c101110040.tgcon(e)
	return Duel.IsExistingMatchingCard(Card.IsPosition,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
end
function c101110040.spfilter(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE|POS_FACEDOWN_DEFENSE)
end
function c101110040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c101110040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110040.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101110040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101110040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)~=0 and tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
end