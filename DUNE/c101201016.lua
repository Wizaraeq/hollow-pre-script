--ネムレリアの夢喰い－レヴェイユ
function c101201016.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,101201016)
	e1:SetCost(c101201016.spcost)
	e1:SetTarget(c101201016.sptg)
	e1:SetOperation(c101201016.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101201016,ACTIVITY_SPSUMMON,c101201016.counterfilter)
	--Set 1 "Nemurelia" Trap from your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201016,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101201016+100)
	e2:SetCost(c101201016.setcost)
	e2:SetTarget(c101201016.settg)
	e2:SetOperation(c101201016.setop)
	c:RegisterEffect(e2)
end
function c101201016.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_PENDULUM)
end
function c101201016.rmcfilter(c)
	return not c:IsCode(70155677) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c101201016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101201016,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c101201016.rmcfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101201016.rmcfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	--Cannot Special Summon from the Extra Deck, except Pendulum Monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101201016.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101201016.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
function c101201016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101201016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101201016.tgcfilter(c)
	return c:IsLevel(10) and c:IsRace(RACE_BEAST) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c101201016.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101201016.tgcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101201016.tgcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101201016.setfilter(c)
	return c:IsSetCard(0x191) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101201016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201016.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101201016.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101201016.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end