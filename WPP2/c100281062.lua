--マジシャンズ・サルベーション
function c100281062.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100281062+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100281062.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11711438,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,11711438+100)
	e1:SetCondition(c100281062.spcon)
	e1:SetTarget(c100281062.sptg)
	e1:SetOperation(c100281062.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c100281062.filter(c)
	return c:IsCode(48680970) and c:IsSSetable()
end
function c100281062.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100281062.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100281062,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
	end
end
function c100281062.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(46986414,38033121) and c:IsSummonPlayer(tp)
end
function c100281062.tgfilter(c,e,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c100281062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c100281062.spfilter(c,e,tp,code)
	return c:IsCode(46986414,38033121) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100281062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100281062.cfilter,1,nil,tp)
end
function c100281062.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c100281062.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100281062.tgfilter(chkc,e,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(c100281062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,g) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c100281062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100281062.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100281062.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end