--戦華史略－矯詔之叛

--Script by Chrono-Genex
function c101108064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108064,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101108064)
	e2:SetTarget(c101108064.sptg)
	e2:SetOperation(c101108064.spop)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108064,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101108064+100)
	e3:SetCost(c101108064.attcost)
	e3:SetTarget(c101108064.atttg)
	e3:SetOperation(c101108064.attop)
	c:RegisterEffect(e3)
end
function c101108064.spfilter(c,e,tp)
	return c:IsSetCard(0x137) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101108064.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101108064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101108064.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(tp,tc:GetLevel()*100,REASON_EFFECT)
	end
end
function c101108064.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101108064.attfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x137)
end
function c101108064.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101108064.attfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101108064.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c101108064.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	e:SetLabel(tc:GetControler())
end
function c101108064.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local catt=tc:GetAttribute()
		local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-catt)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if e:GetLabel()==1-tp and tc:IsControler(1-tp) and tc:IsControlerCanBeChanged()
			and Duel.SelectYesNo(tp,aux.Stringid(101108064,2)) then
			Duel.GetControl(tc,tp)
		end
	end
end
