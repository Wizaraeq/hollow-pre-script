--エヴォルド・フォリス
function c101201017.initial_effect(c)
	--Special Summon 1 "Evoltile" monster from the hand or GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101201017)
	e1:SetTarget(c101201017.sptg)
	e1:SetOperation(c101201017.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Set 1 "Evo-Force" or "Evo-Instant" from the Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201017,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101201017+100)
	e3:SetTarget(c101201017.settg)
	e3:SetOperation(c101201017.setop)
	c:RegisterEffect(e3)
	--Destruction replacement
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101201017.reptg)
	e4:SetValue(c101201017.repval)
	e4:SetOperation(c101201017.repop)
	c:RegisterEffect(e4)
end
function c101201017.filter(c,e,tp)
	return c:IsSetCard(0x304e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
end
function c101201017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101201017.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c101201017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101201017.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101201017.setfilter(c)
	return c:IsCode(5338223,24362891) and c:IsSSetable()
end
function c101201017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201017.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101201017.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101201017.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function c101201017.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c101201017.cfilter(c,e)
	return c:IsRace(RACE_REPTILE+RACE_DINOSAUR) and c:IsReleasableByEffect(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c101201017.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c101201017.repfilter,nil,tp)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c101201017.cfilter,tp,LOCATION_MZONE,0,1,nil,e)  end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c101201017.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e)
		Duel.SetTargetCard(tg)
		return true
	else
		return false
	end
end
function c101201017.repval(e,c)
	return c101201017.repfilter(c,e:GetHandlerPlayer())
end
function c101201017.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,101201017)
	local tc=Duel.GetFirstTarget()
	Duel.Release(tc,REASON_EFFECT+REASON_REPLACE)
end