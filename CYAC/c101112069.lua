--サイバネット・サーキット
function c101112069.initial_effect(c)
	--Special Summon monsters from the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112069,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101112069)
	e1:SetTarget(c101112069.target)
	e1:SetOperation(c101112069.activate)
	c:RegisterEffect(e1)
	--Return a "Firewall" monster to the Extra Deck and Special Summon it
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112069,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101112069+100)
	e2:SetCondition(c101112069.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101112069.tdtg)
	e2:SetOperation(c101112069.tdop)
	c:RegisterEffect(e2)
end
function c101112069.tgfilter(c,e,tp)
	return c:IsSetCard(0x28f) and c:IsType(TYPE_LINK)
		and (Duel.IsExistingMatchingCard(c101112069.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,c:GetLinkedZone(tp),tp)
		or Duel.IsExistingMatchingCard(c101112069.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,c:GetLinkedZone(1-tp),1-tp))
end
function c101112069.get_zone(c,tc,tp)
	local zone=0
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then
		if c:IsLinkMarker(LINK_MARKER_LEFT) and seq < 4 and (not clink or tc:IsLinkMarker(LINK_MARKER_RIGHT)) then zone=zone|(1<<seq+1) end
		if c:IsLinkMarker(LINK_MARKER_RIGHT) and seq > 0 and seq <= 4 and (not clink or tc:IsLinkMarker(LINK_MARKER_LEFT)) then zone=zone|(1<<seq-1) end
		if c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT)) then zone=zone|(1<<2*(seq-5)) end
		if c:IsLinkMarker(LINK_MARKER_TOP) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM)) then zone=zone|(1<<2*(seq-5)+1) end
		if c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT)) then zone=zone|(1<<2*(seq-5)+2) end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and (seq == 0 or seq == 2) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT)) then zone=zone|(1<<5+seq/2) end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM) and (seq == 1 or seq == 3) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP)) then zone=zone|(1<<5+(seq-1)/2) end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and (seq == 2 or seq == 4) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_LEFT)) then zone=zone|(1<<5+(seq-2)/2) end
	elseif tc:IsLocation(LOCATION_MZONE) then
		if c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and (seq == 5 or seq == 6 or ((seq == 0 or seq == 2))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+2)
			else
				zone=zone|(1<<-seq/2+6)
			end
		end
		if c:IsLinkMarker(LINK_MARKER_TOP) and (seq == 5 or seq == 6 or ((seq == 1 or seq == 3))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+3)
			else
				zone=zone|(1<<-(seq-1)/2+6)
			end
		end
		if c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and (seq == 2 or seq == 4 or ((seq == 2 or seq == 4))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_LEFT)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+4)
			else
				zone=zone|(1<<-(seq-2)/2+6)
			end
		end
	end
	return zone
end
function c101112069.spfilter(c,e,summonPlayer,targetCard,targetCardZones,toFieldPlayer)
	local zone=targetCardZones|(c:IsType(TYPE_LINK) and c101112069.get_zone(c,targetCard,toFieldPlayer) or 0)
	return zone>0 and c:IsCanBeSpecialSummoned(e,0,summonPlayer,false,false,POS_FACEUP,toFieldPlayer,zone)
end
function c101112069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101112069.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)
		and Duel.IsExistingTarget(c101112069.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101112069.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101112069.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(tp),tp)
	local g2=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(1-tp),1-tp)
	if #(g1+g2)>0 then
	repeat
		local g1=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(tp),tp)
		local g2=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(1-tp),1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=(g1+g2):Select(tp,1,1,nil):GetFirst()
		local seq=tc:GetSequence()
		local b1=g1:IsContains(sc)
		local b2=g2:IsContains(sc)
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101112069,2),aux.Stringid(101112069,3))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(101112069,2))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101112069,3))+1
		end
		local toFieldPlayer=op==0 and tp or 1-tp
		local zone=tc:GetLinkedZone(toFieldPlayer)
		if sc:IsType(TYPE_LINK) then
			zone=bit.bor(zone,c101112069.get_zone(sc,tc,toFieldPlayer))
		end
		Duel.SpecialSummonStep(sc,0,tp,toFieldPlayer,false,false,POS_FACEUP,zone)
		local g1=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(tp),tp)
		local g2=Duel.GetMatchingGroup(c101112069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetLinkedZone(1-tp),1-tp)
		until #(g1+g2)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101112069,4))
	end
	Duel.SpecialSummonComplete()
end
function c101112069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c101112069.tdfilter(c)
	return c:IsSetCard(0x28f) and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function c101112069.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112069.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c101112069.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101112069.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g,true)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local sc=Duel.GetOperatedGroup():GetFirst()
		if sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(101112069,5)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
