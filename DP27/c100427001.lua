--Ｄ・テレホン
function c100427001.initial_effect(c)
	--atk pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100427001,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100427001.cona)
	e1:SetTarget(c100427001.tga)
	e1:SetOperation(c100427001.opa)
	c:RegisterEffect(e1)
	--def pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100427001,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100427001.cond)
	e2:SetTarget(c100427001.tgd)
	e2:SetOperation(c100427001.opd)
	c:RegisterEffect(e2)
end
c100427001.toss_dice=true
function c100427001.cona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c100427001.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c100427001.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c100427001.spfilter(c,lv,e,tp)
	return c:IsSetCard(0x26) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100427001.opa(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossDice(tp,1)
	if Duel.Recover(tp,res*100,REASON_EFFECT)~=res*100 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100427001.spfilter),tp,LOCATION_GRAVE,0,nil,res,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100427001,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100427001.tgd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c100427001.tgfilter(c)
	return c:IsSetCard(0x26) and c:IsAbleToGrave()
end
function c100427001.opd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc):Filter(c100427001.tgfilter,nil)
	local ct=0
	if #dg>0 and Duel.SelectYesNo(p,aux.Stringid(100427001,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=dg:Select(tp,1,1,nil)
		dg:RemoveCard(tg:GetFirst())
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tg,REASON_EFFECT)
		ct=1
	end
	local ac=dc-ct
	if ac==0 then return end
	local op=Duel.SelectOption(tp,aux.Stringid(100427001,4),aux.Stringid(100427001,5))
	Duel.SortDecktop(tp,tp,ac)
	if op==0 then return end
	for i=1,ac do
		local tg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(tg:GetFirst(),SEQ_DECKBOTTOM)
	end
end