--星騎士 セイクリッド・カドケウス
function c101112045.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--Add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112045,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112045)
	e1:SetCondition(c101112045.thcon)
	e1:SetTarget(c101112045.thtg)
	e1:SetOperation(c101112045.thop)
	c:RegisterEffect(e1)
	--Apply the effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112045,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112045+100)
	e2:SetCost(c101112045.applycost)
	e2:SetTarget(c101112045.applytg)
	e2:SetOperation(c101112045.applyop)
	c:RegisterEffect(e2)
end
function c101112045.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101112045.thfilter(c,e)
	return c:IsSetCard(0x9c,0x53) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c101112045.rescon(sg)
	return #sg==1 or (sg:IsExists(Card.IsSetCard,1,nil,0x9c) and sg:IsExists(Card.IsSetCard,1,nil,0x53))
end
function c101112045.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101112045.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	tg=g:SelectSubGroup(tp,c101112045.rescon,false,1,2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,tp,0)
end
function c101112045.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101112045.tgfilter(c)
	return c:IsSetCard(0x9c) and not c:IsCode(1050186) and c:IsAbleToGrave()
end
function c101112045.telafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9c)
end
function c101112045.escfilter(c,dc)
	if dc:IsCode(14759024,78486968,42391240) and not (c:IsSetCard(0x53) and c:IsType(TYPE_MONSTER)) then return false end
	if dc:IsCode(75878039,26057276) and not (c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER) and not c:IsCode(dc:GetCode())) then return false end
	if dc:IsCode(101112021) and not (c:IsSetCard(0x9c) and c:IsType(TYPE_SPELL)) then return false end
	return c:IsAbleToHand()
end
function c101112045.dbrfilter(c,e,tp,dc)
	if dc:IsCode(40143123,16906241,2273734) then pos=POS_FACEUP_DEFENSE else pos=POS_FACEUP end
	if dc:IsCode(16906241) and not c:IsSetCard(0x53) then return false end
	if dc:IsCode(15871676) and not (c:IsSetCard(0x53) and c:IsLevel(3)) then return false end
	if dc:IsCode(40143123) and not (c:IsSetCard(0x53) and c:IsLevel(5)) then return false end
	if dc:IsCode(41269771) and not (c:IsSetCard(0x53) and c:IsLevel(4)) then return false end
	if dc:IsCode(38667773) and not (c:IsSetCard(0x9c) and not c:IsCode(38667773)) then return false end
	if dc:IsCode(2273734) and not (c:IsSetCard(0x9c) and not c:IsCode(2273734)) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function c101112045.acbfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x53)
end
function c101112045.tdfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101112045.disfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER)
end
function c101112045.desfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9c,0xc4)
end
function c101112045.desfilter2(c,dc)
	if dc:IsCode(22617205) then
	return c:IsFacedown()
	elseif dc:IsCode(96223501) then
	return c:IsFaceup()
	end
end
function c101112045.descfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101112045.rmvfilter(c,e,tp,tc)
	if not (c:IsSetCard(0x9c,0x53) and c:IsAbleToRemoveAsCost()) then return false end
	if c:IsCode(1050186) then
		return Duel.IsExistingMatchingCard(c101112045.tgfilter,tp,LOCATION_DECK,0,1,c)
	elseif c:IsCode(2273734) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101112045.dbrfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
	elseif c:IsCode(13851202) then
		return Duel.IsExistingTarget(c101112045.telafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	elseif c:IsCode(14759024,78486968,75878039,101112021) then
		return Duel.IsExistingMatchingCard(c101112045.escfilter,tp,LOCATION_DECK,0,1,c,c)
	elseif c:IsCode(15871676,16906241,40143123,41269771,38667773) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112045.dbrfilter,tp,LOCATION_HAND,0,1,c,e,tp,c)
	elseif c:IsCode(42391240,26057276) then
		return Duel.IsExistingTarget(c101112045.escfilter,tp,LOCATION_GRAVE,0,1,nil,c)
	elseif c:IsCode(43513897) then
		return Duel.IsExistingMatchingCard(c101112045.acbfilter,tp,LOCATION_MZONE,0,1,c)
	elseif c:IsCode(63274863) then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c101112045.tdfilter,tp,LOCATION_GRAVE,0,5,nil)
	elseif c:IsCode(65056481,86466163) then
		return true
	elseif c:IsCode(99668578) then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c101112045.disfilter,tp,LOCATION_HAND,0,1,c)
	elseif c:IsCode(22617205,96223501) then
		return Duel.IsExistingTarget(c101112045.desfilter1,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,tc)
		and Duel.IsExistingTarget(c101112045.desfilter2,tp,0,LOCATION_ONFIELD,1,nil,c)
	elseif c:IsCode(101112020) then
		return Duel.IsExistingMatchingCard(c101112045.descfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
end
function c101112045.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101112045.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c101112045.rmvfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,c)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112045.rmvfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,c)
	local dc=g:GetFirst()
	e:SetLabelObject(dc)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	if dc:IsCode(1050186) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif dc:IsCode(2273734) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112045.dbrfilter(chkc,e,tp,dc) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c101112045.dbrfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,dc)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif dc:IsCode(13851202) then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112045.telafilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c101112045.telafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c101112045.telafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		elseif dc:IsCode(14759024,78486968,75878039) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif dc:IsCode(15871676,16906241,40143123,41269771,38667773) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif dc:IsCode(42391240,26057276) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112045.escfilter(chkc,dc) end
		if chk==0 then return Duel.IsExistingTarget(c101112045.escfilter,tp,LOCATION_GRAVE,0,1,nil,dc) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c101112045.escfilter,tp,LOCATION_GRAVE,0,1,1,nil,dc)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	elseif dc:IsCode(43513897) then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif dc:IsCode(63274863) then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112045.tdfilter(chkc) end
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c101112045.tdfilter,tp,LOCATION_GRAVE,0,5,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c101112045.tdfilter,tp,LOCATION_GRAVE,0,5,5,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif dc:IsCode(65056481) then
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	elseif dc:IsCode(99668578) then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif dc:IsCode(22617205,96223501) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return false end
		if chk==0 then return Duel.IsExistingTarget(c101112045.desfilter1,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c101112045.desfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,c101112045.desfilter1,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,c101112045.desfilter2,tp,0,LOCATION_ONFIELD,1,1,nil,dc)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	elseif dc:IsCode(101112020) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsOnField() end
		if chk==0 then return Duel.IsExistingMatchingCard(c101112045.descfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		local ct=Duel.GetMatchingGroupCount(c101112045.descfilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
end
function c101112045.applyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	if dc:IsCode(1050186) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101112045.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif dc:IsCode(2273734) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101112045.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif dc:IsCode(13851202) then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCountLimit(1)
		e2:SetOperation(c101112045.tgop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
	elseif dc:IsCode(14759024,78486968,75878039,101112021) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101112045.escfilter,tp,LOCATION_DECK,0,1,1,nil,dc)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	elseif dc:IsCode(15871676,16906241,40143123,41269771,38667773) then
		if dc:IsCode(40143123,16906241) then pos=POS_FACEUP_DEFENSE else pos=POS_FACEUP end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101112045.dbrfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,dc)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,pos)
		end
	elseif dc:IsCode(42391240) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		end
	elseif dc:IsCode(43513897) then
		local g=Duel.GetMatchingGroup(c43513897.filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		end
	elseif dc:IsCode(26057276) then
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		end
	elseif dc:IsCode(63274863) then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==5 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif dc:IsCode(65056481) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	elseif dc:IsCode(86466163) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101112045.xyztg)
		e1:SetValue(c101112045.xyzlv)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif dc:IsCode(99668578) then
		if Duel.DiscardHand(tp,c101112045.disfilter,1,1,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		end
	elseif dc:IsCode(22617205,96223501,101112020) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c101112045.atktg(e,c)
	return not c:IsSetCard(0x9c)
end
function c101112045.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c101112045.xyztg(e,c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x9c)
end
function c101112045.xyzlv(e,c,rc)
	return 0x30050000+c:GetLevel()
end