--原質の円環炉
function c101108066.initial_effect(c)
	--Detach 1 Xyz material from your monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101108066.target)
	e1:SetOperation(c101108066.activate)
	c:RegisterEffect(e1)
end
function c101108066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
end
function c101108066.sgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c101108066.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
	for tc in aux.Next(mg) do
		g:Merge(tc:GetOverlayGroup())
	end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
	local og=Duel.GetOperatedGroup():Filter(c101108066.sgfilter,nil,tp)
	--Set the detached card
	if og:GetCount()>0 then
		local rc=og:GetFirst()
		if (rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and rc:IsControler(tp)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(101108066,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and rc:IsControler(tp)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(101108066,0)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			end
		end
	end
end