--超越進化薬β
function c101201063.initial_effect(c)
	--Special Summon 1 level 5 or higher Dinosaur monster from the Deck or Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201063,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101201063+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101201063.cost)
	e1:SetTarget(c101201063.target)
	e1:SetOperation(c101201063.activate)
	c:RegisterEffect(e1)
end
function c101201063.spcheck(sg,e,tp)
	return sg:IsExists(Card.IsRace,1,nil,RACE_DINOSAUR)
		and Duel.IsExistingMatchingCard(c101201063.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function c101201063.spfilter(c,e,tp,sg)
	local atk=sg:GetSum(Card.GetAttack)
	if not (c:IsAttackAbove(atk) and c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)) then return end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetMZoneCount(tp,sg)>0
	else
		return Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
end
function c101201063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp)
	if chk==0 then return g:CheckSubGroup(c101201063.spcheck,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c101201063.spcheck,false,2,2,e,tp)
	e:SetLabel(sg:GetSum(Card.GetAttack))
	Duel.Release(sg,REASON_COST)
end
function c101201063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101201063.activate(e,tp,eg,ep,ev,re,r,rp)
	--Cannot Special Summon from the Extra Deck, except Dragon, Dinosaur, Sea Serpent, and Wyrm monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101201063.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101201063.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c101201063.spfilter2(c,e,tp,atk)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(5)
		and c:IsAttackAbove(atk) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)) or Duel.GetLocationCountFromEx(tp,tp)>0)
end
function c101201063.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DINOSAUR+RACE_DRAGON+RACE_SEASERPENT+RACE_WYRM) 
end
function c101201063.lizfilter(e,c)
	return not c:IsRace(RACE_DINOSAUR+RACE_DRAGON+RACE_SEASERPENT+RACE_WYRM)
end