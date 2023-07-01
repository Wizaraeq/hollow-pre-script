--エレキングダム
--coded by Lyris
--Wattkingdom
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.actlim)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.lfilter(c,tp)
	return c:IsSetCard(0xe) and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.actlim(e,re,tp)
	local rc=re:GetHandler()
	local efftyp=re:GetType()
	local effcod=re:GetCode()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOnField()
		and (e:GetHandler():GetColumnGroup():IsContains(rc) or rc:GetColumnGroup():IsExists(s.lfilter,1,nil,e:GetHandlerPlayer()))
		and efftyp&EFFECT_TYPE_SINGLE>0 and ((efftyp&EFFECT_TYPE_TRIGGER_O)>0 or (efftyp&EFFECT_TYPE_TRIGGER_F))
		and (effcod==EVENT_SUMMON_SUCCESS or effcod==EVENT_SPSUMMON_SUCCESS)
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xe) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function s.filter(c,e,tp,code)
	return c:IsSetCard(0xe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.splim(e,c)
	return c:GetRace()~=RACE_THUNDER
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode()):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 and aux.nzatk(sc) then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-sc:GetAttack())
	end
end