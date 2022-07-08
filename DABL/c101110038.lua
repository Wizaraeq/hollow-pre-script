--冥占術姫タロットレイス
function c101110038.initial_effect(c)
	--Special Summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c101110038.spconvalue)
	c:RegisterEffect(e0)
	--FLIP: Special Summon 1 Flip monster from Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110038,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101110038)
	e1:SetTarget(c101110038.sptg)
	e1:SetOperation(c101110038.spop)
	c:RegisterEffect(e1)
	--Flip face-up or face-down any number of monsters.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110038,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,101110038+100)
	e2:SetTarget(c101110038.postg)
	e2:SetOperation(c101110038.posop)
	c:RegisterEffect(e2)
end
function c101110038.spconvalue(e,se,sp,st)
	return aux.ritlimit(e,se,sp,st) or se:GetHandler():IsCode(94997874)
end
function c101110038.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c101110038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110038.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101110038.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c101110038.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101110038.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101110038.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c101110038.posfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101110038,2),aux.Stringid(101110038,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101110038,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101110038,3))+1
	end
	e:SetLabel(op)
	local pos=op==0 and POS_FACEUP_DEFENSE or POS_FACEDOWN_DEFENSE
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,pos)
end
function c101110038.posop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if not op then return end
	local filter=op==0 and Card.IsFacedown or c101110038.posfilter
	local g=Duel.GetMatchingGroup(filter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	local pos=op==0 and POS_FACEUP_DEFENSE or POS_FACEDOWN_DEFENSE
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.ChangePosition(g:Select(tp,1,#g,nil),pos)
end