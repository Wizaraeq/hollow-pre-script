--グランドレミコード・クーリア
function c101112049.initial_effect(c)
	c:EnableReviveLimit()
	--2+ monsters, including a Pendulum Monster
	aux.AddLinkProcedure(c,nil,2,3,c101112049.lcheck)
	--Gains 100 ATK for each face-up Pendulum Monster in the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101112049.atkval)
	c:RegisterEffect(e1)
	--Activated effects of Pendulum Monsters this card points to cannot be negated
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101112049.effval)
	c:RegisterEffect(e2)
	--Special Summon 1 "Solfachord" card with an odd Pendulum Scale
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112049,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101112049.spcon)
	e3:SetTarget(c101112049.sptg)
	e3:SetOperation(c101112049.spop)
	c:RegisterEffect(e3)
end
function c101112049.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c101112049.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101112049.atkval(e,c)
	return Duel.GetMatchingGroupCount(c101112049.filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)*100
end
function c101112049.effval(e,ct)
	local c=e:GetHandler()
	local p=c:GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return te:GetHandler():IsType(TYPE_PENDULUM) and c:GetLinkedGroup():IsContains(te:GetHandler())
end
function c101112049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c101112049.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x162) and c:GetCurrentScale()%2~=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101112049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and Duel.IsExistingMatchingCard(c101112049.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101112049.tefilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==0 and not c:IsForbidden()
end
function c101112049.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c101112049.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,zone)
	if #sg==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)==0 or not Duel.NegateActivation(ev) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c101112049.tefilter,tp,LOCATION_DECK,0,nil)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(101112049,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local pg=g:Select(tp,1,1,nil)
	if #pg>0 then
		Duel.BreakEffect()
		Duel.SendtoExtraP(pg,tp,REASON_EFFECT)
	end
end
