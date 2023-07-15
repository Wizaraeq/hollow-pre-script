--ＴＧ ロケット・サラマンダー
function c101202003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101202003)
	e1:SetCost(c101202003.spcost1)
	e1:SetTarget(c101202003.sptg1)
	e1:SetOperation(c101202003.spop1)
	c:RegisterEffect(e1)
	--spsummon 1 tg from gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101202003+100)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c101202003.spcon)
	e2:SetTarget(c101202003.sptg2)
	e2:SetOperation(c101202003.spop2)
	c:RegisterEffect(e2)
end
function c101202003.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101202003.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x27) and Duel.IsExistingMatchingCard(c101202003.spfilter1,tp,LOCATION_DECK,0,1,nil,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function c101202003.spfilter1(c,tc,e,tp)
	return c:GetOriginalCodeRule()~=tc:GetOriginalCodeRule()
		and c:IsSetCard(0x27)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101202003.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101202003.costfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c101202003.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101202003.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101202003.spfilter1,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101202003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27) and c:IsRace(RACE_MACHINE)
end
function c101202003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101202003.filter(c,e,tp)
	return c:IsSetCard(0x27) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101202003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101202003.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101202003.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101202003.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101202003.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end