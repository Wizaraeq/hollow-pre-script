--メメント・シーホース
function c100421003.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100421003)
	e1:SetCondition(c100421003.spcon)
	e1:SetTarget(c100421003.sptg)
	e1:SetOperation(c100421003.spop)
	c:RegisterEffect(e1)
	-- Send cards from the Deck to the GY with a total Levels equal to or lower than the destroyed monster's original Level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421003,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100421003+100)
	e2:SetTarget(c100421003.tgtg)
	e2:SetOperation(c100421003.tgop)
	c:RegisterEffect(e2)
end
function c100421003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:FilterCount(Card.IsSetCard,nil,0x2a1)==#g
end
function c100421003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100421003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100421003.rescon(sg,lv)
	return sg:GetSum(Card.GetLevel)<=lv
end
function c100421003.desfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	local g=Duel.GetMatchingGroup(c100421003.tgfilter,tp,LOCATION_DECK,0,nil,lv)
	return c:IsFaceup() and c:IsSetCard(0x2a1) and g:CheckSubGroup(c100421003.rescon,1,#g,lv)
end
function c100421003.tgfilter(c,lv)
	return c:IsSetCard(0x2a1) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:IsAbleToGrave()
end
function c100421003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421003.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100421003.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c100421003.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local lv=tc:GetOriginalLevel()
		local g=Duel.GetMatchingGroup(c100421003.tgfilter,tp,LOCATION_DECK,0,nil,lv)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		aux.GCheckAdditional=aux.dncheck
		local sg=g:SelectSubGroup(tp,c100421003.rescon,false,1,#g,lv)
		aux.GCheckAdditional=nil
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
