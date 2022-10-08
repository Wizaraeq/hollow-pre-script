--甲虫合体ゼクスタッガー
function c100200226.initial_effect(c)
	-- Gain AT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100200226.atkval)
	c:RegisterEffect(e1)
	-- Special Summon this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200226,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100200226)
	e2:SetCondition(c100200226.hspcon)
	e2:SetTarget(c100200226.hsptg)
	e2:SetOperation(c100200226.hspop)
	c:RegisterEffect(e2)
	-- Each player can summon 1 Insect monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200226,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100200226+100)
	e3:SetTarget(c100200226.sptg)
	e3:SetOperation(c100200226.spop)
	c:RegisterEffect(e3)
end
function c100200226.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100200226.atkval(e,c)
	return Duel.GetMatchingGroupCount(c100200226.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())*300
end
function c100200226.hspfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100200226.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100200226.hspfilter,1,nil)
end
function c100200226.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100200226.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100200226.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE+LOCATION_HAND)
end
function c100200226.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200226.insectsp(p,e,tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(p,LOCATION_MZONE)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100200226.spfilter),p,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if #g==0 or not Duel.SelectYesNo(p,aux.Stringid(100200226,2)) then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local tc=g:Select(p,1,1,nil):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c100200226.spop(e,tp,eg,ep,ev,re,r,rp)
	local turn_p=Duel.GetTurnPlayer()
	c100200226.insectsp(turn_p,e,tp)
	c100200226.insectsp(1-turn_p,e,tp)
	Duel.SpecialSummonComplete()
end