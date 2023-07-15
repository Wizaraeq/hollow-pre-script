--メメント・ボーン・バック
function c100421010.initial_effect(c)
	-- Special Summon 1 "Mementoral Tectolica, the Netherskull Dragon" from your Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,100421010)
	e1:SetCondition(c100421010.spcon)
	e1:SetTarget(c100421010.sptg)
	e1:SetOperation(c100421010.spop)
	c:RegisterEffect(e1)
	-- Special Summon as many "Memento" monsters as possible 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421010,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100421010+100)
	e2:SetCondition(c100421010.spmanycon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100421010.spmanytg)
	e2:SetOperation(c100421010.spmanyop)
	c:RegisterEffect(e2)
end
function c100421010.cfilter(c,tp)
	return c:IsPreviousSetCard(0x2a1) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c100421010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100421010.cfilter,1,nil,tp)
end
function c100421010.spfilter(c,e,tp)
	return c:IsCode(100421001) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100421010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421010.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100421010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100421010.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c100421010.outgravecfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2a1) and c:IsPreviousControler(tp)
end
function c100421010.spmanycon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c100421010.outgravecfilter,1,nil,tp)
end
function c100421010.spmanyfilter(c,e,tp)
	return c:IsSetCard(0x2a1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c100421010.spmanytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)
		return ct>0 and Duel.IsExistingMatchingCard(c100421010.spmanyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100421010.spmanyop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c100421010.spmanyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if tg:GetCount()==0 or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(tg:GetClassCount(Card.GetCode),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end