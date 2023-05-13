--転生炎獣バースト・グリフォン
function c100428004.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	-- Special Summon 1 Level 7 or lower FIRE monster from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100428004)
	e1:SetTarget(c100428004.sptg)
	e1:SetOperation(c100428004.spop)
	c:RegisterEffect(e1)
	-- Active
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428004,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,100428004+100)
	e2:SetCondition(c100428004.efcon)
	e2:SetTarget(c100428004.efftg)
	e2:SetOperation(c100428004.effop)
	c:RegisterEffect(e2)
end
function c100428004.spfilter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100428004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100428004.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100428004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100428004.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100428004.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-tc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	--Cannot Special Summon, except FIRE monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100428004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100428004.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c100428004.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(Card.IsCode,1,nil,100428004)
end
function c100428004.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c100428004.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Special Summon 1 monster from your GY during the next Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	local reset,reset_ct=RESET_PHASE+PHASE_STANDBY,1
	local turn_ct=0
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		reset_ct=2
		turn_ct=Duel.GetTurnCount()
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c100428004.delayspcon)
	e1:SetOperation(c100428004.delayspop)
	e1:SetLabel(turn_ct)
	e1:SetReset(reset,reset_ct)
	Duel.RegisterEffect(e1,tp)
end
function c100428004.delayspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100428004.delayspcon(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	return Duel.IsExistingMatchingCard(c100428004.delayspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and (label==0 or label~=Duel.GetTurnCount())
end
function c100428004.delayspop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100428004.delayspfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end